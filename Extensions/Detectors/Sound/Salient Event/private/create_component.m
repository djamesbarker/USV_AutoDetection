function component = create_component(channel, time, freq, indices, values)

% TODO: add indices or image, so that we may compute further

%--
% handle input
%--

% NOTE: we should be able to factor this

if nargin < 5
	values = [];
end 

if nargin < 4
	indices = [];
end

if nargin < 3
	freq = [];
end

if nargin < 2
	time = [];
end

if nargin < 1
	channel = [];
end 

%--
% set channel and time-frequency fields
%--

component.channel = channel;

component.time = time;

component.duration = diff(time);

component.freq = freq;

component.bandwidth = diff(freq);

%--
% set component description fields
%--

% NOTE: the following fields relate to the discrete event realization

component.indices = indices;

component.values = values(:); 

% NOTE: this is a simple component score distribution description

component.mean = mean(values);

component.range = fast_min_max(values);

%--
% compute meaningfulness of component
%--

% NOTE: this is a very preliminary version if this concept


