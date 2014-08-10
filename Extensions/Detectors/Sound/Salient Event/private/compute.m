function [event, context] = compute(page, parameter, context)

% Salient Event Detector - compute

event = empty(event_create);

%----------------------------
% SETUP
%----------------------------

%--
% create base event
%--

base = event_create;

base.annotation = simple_annotation;

parameter.specgram = context.sound.specgram;
ht = specgram_resolution(parameter.specgram, get_sound_rate(context.sound));

%-------------------------------------------------------
% CORRELATION
%-------------------------------------------------------

%--
% compute signal spectrogram
%--

% TODO: make use of filtered signal optional

% TODO: consider computing both when active and explaining

if ~isempty(page.filtered)
    page.samples = page.filtered;
end

[B, freqs, times] = fast_specgram(page.samples, [], 'norm', parameter.specgram);

if not(isempty(B))
    
    % trim B to desired freq band
    min_freq = parameter.min_freq; max_freq = parameter.max_freq;
    
    freqs_scaled = freqs* context.sound.samplerate / 2;
    low_f = find(freqs_scaled < min_freq, 1, 'last' );
    high_f = find(freqs_scaled > max_freq, 1 );
    
    if isempty(low_f)
        low_f = 1;
    end
    if isempty(high_f)
        high_f = size(B,1);
    end
    B_scaled = B(low_f:high_f,:);
    
    
    
    %%% code from HEART surpsiingly loud feature
    
    %--
    % binarize based on pixel Z-score and label components
    %--
    
    % NOTE: the label operation here uses the 'sieve' parameter
    
    parms.sieve = 1; parms.coalesce =1; parms.threshold = 3; parms.threshold_on = 0;
    % parms.alpha = .25; parms.score = 2;
    parms.alpha = parameter.alpha; parms.score = parameter.score;
    
    
    X = B_scaled;
    if ~iscell(X)
        [D, L] = binarize_and_label(X, parms);
    else
        for k = 1:length(X)
            [D{k}, L{k}] = binarize_and_label(X{k}, parms);
        end
    end
    
    
    %--
    % extract and select components
    %--
    component = pack_components(L, D, parameter, context);
    
    if parms.coalesce
        component = coalesce_components(component);
    end
    
    if parms.threshold_on
        component([component.mean] < parameter.threshold) = [];
    end
    
    %--------------------
    
    % NOTE: some of this could be done by a detection co-processor
    component([component.duration] < parameter.min_dur & [component.bandwidth] < parameter.min_bw) = [];
    
    %--------------------
    
    %--
    % convert components to events
    %--
    nyq = [0, 0.5 * context.sound.samplerate];
    flag=[];
    
    for k = 1:numel(component)
        
        current = component(k);
        
        % TODO: develop these tests, and the reasonable correspoding parameters, use more physics
        time = clip_to_range(current.time - page.start, [0, inf]);
        freq = clip_to_range(current.freq, nyq) + min_freq;
        dur = diff(time);
        bw = diff(freq);
        
        % from orig Heart code
        if (freq(2) < min_freq) || (freq(1) > max_freq)
            % remove event if out of freq range
            flag = [flag k];
        elseif (dur<parameter.min_dur) ||(bw < parameter.min_bw)
            % remove event if bandwidth too tall
            flag = [flag k];
        else
            if (freq(1) < min_freq) && (freq(2) > (min_freq + 10))
                % change event bounds
                freq(1) = min_freq;
            end
            if (freq(2) > max_freq) && (freq(1) < (max_freq - 10))
                freq(2) = max_freq;
            end
        end
        component(k).time = time;
        component(k).freq = freq;
        component(k).duration = dur;
        component(k).bandwidth = abs(diff(freq));
    end
    
    %%%remove flagged events
    flag = unique(flag);
    component(flag) = [];
    
    for k = 1:numel(component)
        
        current = component(k);
        
        event(end + 1) = event_create( ...
            'score', component_score(current), ...
            'channel', current.channel, ...
            'duration', current.duration,...
            'time', current.time, ...
            'freq', current.freq ...
            );
    end
end




%%% SCK from XBAT Heart
%--------------------------
% BINARIZE
%--------------------------

function [D, L] = binarize_and_label(X, parameter, context)

%--
% compute mean, deviation estimate, and loud pixel output
%--

n = size(X, 2);

X(X==0)=eps;

% NOTE: we sort each frequency independently and average the lower energy bins
% parameter.score = 1.5 usually works well;

% SCK: get average of lowest alpha % of values in each frequency band
% E = sort(X(:)); n0 = floor(.01 * n);  M = mean(E(1:n0))*ones(size(X,1),1);
E = sort(X(:)); n0 = floor(parameter.alpha * n);  M = mean(E(1:n0))*ones(size(X,1),1);

% SCK: get euclidean distance of each value in a freq bin from the avergage
% min value, then normalize by row
D = sqrt(sum((X - repmat(M, 1, n)).^2, 2) ./ n);

% SCK: apply adaptive theshold
L = X > repmat(M + parameter.score * D, 1, n);
% NOTE: this test passed, and shows the threshold computation rationale

%--
% select deviation values and label components
%--

L = label_components(uint8(L), parameter);

% NOTE: these values have survived the sieve as well

D = ((X - repmat(M, 1, n)) ./ repmat(D, 1, n)) .* (L > 0);



%--------------------------
% LABEL_COMPONENTS
%--------------------------

function X = label_components(X, parameter, context)

%--
% label components
%--

% TODO: there is a problem when labelling with a non-trivial structuring element

X = comp_label(X);

%--
% sieve to remove noise
%--

% NOTE: this should depend on scale

if parameter.sieve
    X = comp_sieve(X, '[0, 15]');
    % SCK this works for longer calls:  X = comp_sieve(X, '[0, 20]');
end


%--------------------------
% PACK_COMPONENTS
%--------------------------

function component = pack_components(L, D, parameter, context)

%--
% setup
%--

[dt, df] = specgram_resolution(context.sound.specgram, context.sound.samplerate);

page = context.page;

start = context.scan.last_page.start;

nyq = 0.5 * context.sound.samplerate;

%--
% create components
%--

component = empty(create_component);

if numel(page.channels) == 1
    
    key = unique(L); S = size(L);
    
    % NOTE: the first key element is zero, we ignore this one
    
    % remove nans
    key = key(isfinite(key(:, 1)), :);
    
    for k = 2:length(key)
        
        [i, j] = find(L == key(k)); ix = [i(:), j(:)];
        
        T = [-1, 1] + fast_min_max(j) - 0.5; time = start + dt * T;
        
        F = [-1, 1] + fast_min_max(i) - 1; freq = df * F;
        
        component(end + 1) = create_component( ...
            page.channels, time, freq, ix, D(sub2ind(S, i, j)) ...
            );
        
    end
    
else
    
    for l = 1:length(page.channels)
        
        key = unique(L{l}); S = size(L{l});
        
        % NOTE: the first key element is zero, we ignore this one
        
        for k = 2:length(key)
            
            [i, j] = find(L{l} == key(k)); ix = [i(:), j(:)];
            
            T = [-1, 1] + fast_min_max(j) - 0.5; time = start + dt * T;
            
            F = [-1, 1] + fast_min_max(i) - 1; freq = df * F;
            
            component(end + 1) = create_component( ...
                page.channels(l), time, freq, ix, D{l}(sub2ind(S, i, j)) ...
                );
            
        end
        
    end
    
end




%----------------------------
% COMPONENT_SCORE
%----------------------------

function score = component_score(component)

score = 0.5 * (tanh(0.5 * component.mean) + 1);


%-------------------------------------
% GET_FRAGMENT_INDICES
%-------------------------------------

function ix = get_fragment_indices(value)

%--
% compute change in fragment indicator sequence
%--

pad = zeros(1, size(value, 2));

% NOTE: we 'end' edge events with the padding, this ensures the find step finds index pairs

change = diff([pad; value; pad], 1, 1);

%--
% get fragment start and stop indices
%--

% TODO: consider when to discard the edge events in our collection

% NOTE: the cell packing works over channels

ix = {};

for k = 1:size(value, 2)
    current = [find(change > 0), find(change < 0) - 1]; ix{k} = current;
end


%-------------------------------------
% GET_FRAGMENT_DESCRIPTION
%-------------------------------------

function stat = get_fragment_description(value, ix)

% TODO: this function will compute many of the properties we will also use in the score

value = value(ix(1):ix(2));

stat.mean = mean(value);

stat.deviation = std(value);

stat.variation = 100 * (stat.deviation / stat.mean);

stat.quartiles = fast_rank(value, [0.05, 0.25, 0.5, 0.75, 0.95]);

stat.median = stat.quartiles(3);

stat.start = value(1); stat.stop = value(end);


% %------------------------
% % SCORE_EVENT
% %------------------------
%
% function value = score_event(event)
%
% % TODO: compute score considering range, monotone purity, and duration


%------------------------
% SIMPLIFY
%------------------------

function value = simplify(value, scale)

if nargin < 2
    scale = 5;
end

if islogical(value)
    value = double(value);
end

% NOTE: use simple morphological filter to simplify binary change signal

se = ones(scale, 1); value = morph_close(morph_open(value, se), se);


