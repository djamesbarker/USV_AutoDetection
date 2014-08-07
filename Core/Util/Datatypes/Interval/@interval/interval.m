function obj = interval(varargin)

%--
% output trivial interval
%--

if ~nargin
	obj = class(interval_create, 'interval'); return;
end

%--
% create non-trivial interval
%--

obj = interval_create;

obj.type = 'real';

if nargin == 1
	error('Interval creation requires at least a start and stop.');
end

obj.start = varargin{1}; obj.stop = varargin{2};

if obj.start > obj.stop
	error('Interval should start before it stops.');
end
		
if nargin > 2
	obj.points = varargin{3};
else
	obj.points = 20;
end
		
obj = class(obj, 'interval');


%--------------------
% INTERVAL_CREATE
%--------------------

function obj = interval_create

obj.type = 'null'; obj.start = []; obj.stop = []; obj.points = [];
