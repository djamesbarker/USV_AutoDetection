function [A, B, G] = test_event_intersect(n)

% test_code - test event intersection code
% ----------------------------------------
%
% test_event_intersect(n)
%
% Input:
% ------
%  n - number of events to intersect (def: 20)

% TODO: extract component event computation from test code

%--------------------------
% HANDLE INPUT
%--------------------------

%--
% set number of rectangles
%--

if ~nargin || isempty(n)
	n = 8;
end

%--------------------------
% SETUP
%--------------------------

%--
% create random times and frequency bounds
%--

time = sort(rand(n, 2), 2);

time(:, 2) = time(:, 1) + (time(:, 2) / 5);

freq = sort(rand(n, 2), 2); 

freq(:, 2) = freq(:, 1) + (freq(:, 2) / 5);

%--
% create events from bounds
%--

base = event_create;

for k = 1:n
	base.time = time(k, :); base.freq = freq(k, :); event(k) = base;
end

%--------------------------
% INTERSECT EVENTS
%--------------------------

% NOTE: generalize to apply intersection recursively

[A, B] = event_intersect(event);

%--------------------------
% COMPUTE COMPONENTS
%--------------------------

%--
% produce graph representation of intersection
%--

% NOTE: discard intersection weights, weights are very useful information

G.E = sparse_to_edge(double(A ~= 0));

%--
% compute connected components of intersection graph
%--

% NOTE: this code can be improved

[step, comp] = graph_dfs(G);

label = unique(comp);

%--
% compute component rectangles
%--

pad = 0.005; % NOTE: pad is set for display, in XBAT this is part of 'event_view'

comp_event = empty(base);

for k = 1:length(label)

	%--
	% select event using component labels
	%--

	ix = find(comp == label(k));

	%--
	% disregard the trivial components, single event components
	%--

	if length(ix) == 1
		continue;
	end

	%--
	% set time and frequency bounds
	%--

	time = struct_field(event(ix), 'time');
	
	time = [min(time(:, 1)) - pad, max(time(:, 2)) + pad];

	freq = struct_field(event(ix), 'freq');
	
	freq = [min(freq(:, 1)) - pad, max(freq(:, 2)) + pad];

	%--
	% create component event
	%--

	% NOTE: here we can set the level of the events as well

	base.time = time; base.freq = freq; comp_event(end + 1) = base;

end

%----------------------------------------------------
% DISPLAY RESULTS
%----------------------------------------------------

fig;

%--
% display intitial random rectangle events
%--

for k = 1:length(event)
	
	pos = event_to_position(event(k));
	
	rectangle( ...
		'position', pos, ...
		'edgecolor', color_to_rgb('Cyan'), ...
		'linewidth',1 ...
	);

	text(pos(1), pos(2), int2str(k), ...
		'color', 'white', ...
		'fontsize', 12, ...
		'horizontalalignment', 'left', ...
		'verticalalignment', 'bottom' ...
	);
	
end	

%--
% display component events
%--

for k = 1:length(comp_event)
	
	pos = event_to_position(comp_event(k));
	
	rectangle( ...
		'position', pos, ...
		'edgecolor', [1 1 0], ...
		'linestyle',':' ...
	);

end	

%--
% set display properties
%--

set(gca, 'visible', 'off');

set(gcf, 'color', zeros(1, 3));


if ~nargout
	A = full(A), B = full(B), clear A B
end
