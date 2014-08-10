function [result, context] = compute(log, parameter, context)

% FIND GROUPS - compute

result = struct;

parameter.gap = 20;

%--
% get event identifiers, channel, time. compute center times sort by this
%--

id = struct_field(log.event, 'id'); ch = struct_field(log.event, 'channel'); 

time = struct_field(log.event, 'time'); freq = struct_field(log.event, 'freq');

center = mean(time, 2);

[center, pix] = sort(center); id = id(pix); ch = ch(pix);

%--
% compute gaps and join 
%--

event = empty(event_create); 

uch = unique(ch);

for k = 1:numel(uch)
	
	%--
	% get channel events and test for group splits
	%--
	
	ix = find(ch == uch(k)); count = numel(ix);
	
	split = [0; find(diff(center(ix)) > parameter.gap) + 1];
	
	%--
	% get non-trivial groups from split
	%--
	
	group1 = [];
	
	for j = 1:numel(split) - 1
		
		if split(j) + 1 < split(j + 1) - 1
			group1(end + 1, :) = [split(j) + 1, split(j + 1) - 1];
		end
		
	end
	
	disp(' ');
	
	for j = 1:size(group1, 1)
		
		group2{j} = id(ix(group1(j, 1):group1(j, 2)));
		
		disp(mat2str(group2{j}));
		
	end
	
	%--
	% create events from groups
	%--
	
	for j = 1:size(group1, 1)
		
		localt = time(ix(group1(j, 1):group1(j, 2)), :);
		
		localf = freq(ix(group1(j, 1):group1(j, 2)), :);
		
		event(end + 1) = event_create( ...
			'channel', uch(k), 'time', fast_min_max(localt(:)), 'freq', fast_min_max(localf(:)) ...	
		);
		
	end
	
end

%--
% create new log and save events
%--

log = new_log_dialog;

event

log.event = event;

log_save(log);
