function discard = discard_lower_quality(detection, ix)

% discard_lower_quality - determine overlapped events to discard
% --------------------------------------------------------------
%
% discard = discard_lower_quality(detection, ix)
%
% Input:
% ------
%  detection - detection array
%  ix - indices to consider for overlap
%
% Output:
% -------
%  discard - indices of events to discard

% TODO: make use of the relative area overlap output from 'event_intersect'

% TODO: more efficient implementation of test? and some cleanup

%--
% compute event intersection areas
%--

[A, B] = event_intersect(detection(ix));

% NOTE: there should be a matlab way of setting the diagonal to zero

for k = 1:size(A, 1)
    A(k, k) = 0; B(k, k) = 0;
end

%--
% return quickly if there are no overlap events
%--

discard = [];

% if full(sum(A(:))) == 0
%     return;
% end

%--
% get simple conflict mode variable to use during test
%--

mode = ones(1, length(ix));

for k = 1:length(ix)
    mode(1, k) = detection(ix(k)).detection.value.mode;
end

%--
% look through rows of intersection matrix
%--

if full(sum(A(:))) ~= 0
    
    for k = 1:length(ix)
        
        %--
        % check for overlapping events, if none skip processing
        %--
        
        overlap = find(A(k, :));
        
        if isempty(overlap)
            continue;
        end
        
        %--
        % get indices and values from overlapping events
        %--
        
        clear('dix'); clear('value');
        
        % event on diagonal
        
        dix(1) = ix(k); value(1) = detection(ix(k)).detection.value;
        
        % off-diagonal events
        
        for j = 1:length(overlap)
            dix(j + 1) = ix(overlap(j)); value(j + 1) = detection(ix(overlap(j))).detection.value;
        end
        
        %--
        % perform simple quality test, require maximum correlation among intersecting events
        %--
        
        test = [dix', struct_field(value, 'corr')];
        
        % NOTE: the max function returns the first index to a max, on ties we will keep
        
        [ignore, top] = max(test(:, 2));
        
        % NOTE: if the current event is not a top it will be discarded
        
        if top ~= 1
            discard = [discard, ix(k)];
        end
        
    end
    
end

%--
% update discard list to include reject mode templates
%--

% NOTE: the number 3 is the code for rejection

rix = find(mode == 3);

if ~isempty(rix)
    discard = [discard ix(rix)];
end

%--
% compute unique discard indices
%--

discard = unique(discard);

%--
% update discard list to exclude non-exclusive templates
%--

% NOTE: the number 2 is the code for always keeping

kix = find(mode == 2);

if ~isempty(kix)
    discard = setdiff(discard, ix(kix));
end

