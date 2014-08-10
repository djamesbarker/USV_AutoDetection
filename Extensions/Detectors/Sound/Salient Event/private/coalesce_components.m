function [coalesced, merge] = coalesce_components(component, rec, dilate)

%----------------------------
% HANDLE INPUT
%----------------------------

%--
% handle empty component input
%--

if isempty(component)
	coalesced = component; merge = 0; return;
end

%--
% set default dilation
%--

% NOTE: interpret negative numbers as percent, positive as absolute

% TODO: there are problems with the time dilation, it must be off for now!!

if nargin < 3
	dilate = [0, -0.5];
    %%%SCK
%     dilate = [0,-2];
end

%--
% set default recursive computation
%--

if nargin < 2
	rec = 1;
end

%--
% coalesce each channel separately
%--

channels = [component.channel];

% NOTE: this intends to be a fast test for multiple channels

if find(channels ~= component(1).channel, 1)
	
	channel = unique(channels); coalesced = []; merge = 0;
	
	for k = 1:length(channel)
		
		[part, some] = coalesce_components(component(channels == channel(k)), rec, dilate);
		
		coalesced = [coalesced, part]; merge = merge + some;
		
	end
	
	return;
	
end

%--
% coalesce recursively
%--

if rec
	
	% NOTE: it seems like we only dilate in the first step of the recursion
	
	[coalesced, merge] = coalesce_components(component, 0, dilate);
	
	while merge
		[coalesced, merge] = coalesce_components(coalesced, 0, [0, 0]);
	end

	return;
	
end
	
%----------------------------
% COMPUTE INTERSECTION
%----------------------------

dilated = dilate_component(component, dilate);

%--
% produce graph representation of intersection using dilated components
%--

A = event_intersect(dilated);

% NOTE: discard intersection weights, weights are potentially very useful information

A = double(A ~= 0);

G.E = sparse_to_edge(A);

%--
% compute connected components of intersection graph
%--

% NOTE: the DFS code can be improved

[step, comp] = graph_dfs(G);

label = unique(comp);

%--
% compute component rectangles
%--

coalesced = empty(create_component); merge = 0;

for k = 1:length(label)

	%--
	% select graph component components using labels
	%--

	ix = find(comp == label(k));

	%--
	% no need to coalesce isolated components
	%--

	if length(ix) == 1
		coalesced(end + 1) = component(ix); continue;
	end

	%--
	% compute fields of coalesced component
	%--
	
	% NOTE: all component components have the same channel
	
	channel = component(ix(1)).channel;
	
	% NOTE: the use of 'struct_field' saves us some reshaping
	
	time = struct_field(component(ix), 'time');
	
	time = [min(time(:, 1)), max(time(:, 2))];

	freq = struct_field(component(ix), 'freq');
	
	freq = [min(freq(:, 1)), max(freq(:, 2))];
	
	indices = []; values = [];
	
	for j = 1:length(ix)
		indices = [indices; component(ix(j)).indices]; values = [values; component(ix(j)).values];
	end
	
	%--
	% create coalesced component
	%--

	% NOTE: the score mean and range of the score values is computed by create, not very efficient but simple and correct
	
	coalesced(end + 1) = create_component(channel, time, freq, indices, values);
	
	merge = merge + 1;
	
end


%----------------------------
% DILATE_COMPONENT
%----------------------------

function component = dilate_component(component, rate)

%--
% handle rate input
%--

if nargin < 2 || all(rate == 0)
	return;
end

%--
% handle component array
%--

if numel(component) > 1
	
	for k = 1:numel(component)
		component(k) = dilate_component(component(k), rate);
	end
	
	return;
	
end

%--
% dilate component
%--
		
component.time = dilate_interval(component.time, rate(1));

component.freq = dilate_interval(component.freq, rate(2));


%----------------------------
% DILATE_INTERVAL
%----------------------------

function interval = dilate_interval(interval, rate, range)

%--
% set no range default
%--

if nargin < 3
	range = []; 
end 

%--
% handle rate input
%--

if nargin < 2 || rate == 0
	return;
end

%--
% dilate interval
%--

% NOTE: positive rate is absolute, negative is relative

if rate > 0
	interval = interval + rate * [-1, 1];
else
	interval = interval + abs(rate) * diff(interval) * [-1, 1];
end

if ~isempty(range)
	interval = clip_to_range(interval, range);
end

