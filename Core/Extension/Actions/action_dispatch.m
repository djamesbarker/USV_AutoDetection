function result = action_dispatch(obj, eventdata, type, varargin)

% action_dispatch - dispatch action extension
% -------------------------------------------
%
% result = action_dispatch(obj, eventdata, type)
%
% Input:
% ------
%   obj - callback object
%   eventdata - callback event data
%   type - action type
%
% Output:
% -------
%  result - results of action

% Copyright (C) 2002-2012 Cornell University

%
% This file is part of XBAT.
% 
% XBAT is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 2 of the License, or
% (at your option) any later version.
% 
% XBAT is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with XBAT; if not, write to the Free Software
% Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA

% NOTE: consider not updating the results section during prepare and conclude

% NOTE: the passing of type around is quirky and should be considered

%-------------------------------
% HANDLE INPUT
%-------------------------------

%--
% check for valid type input
%--

% NOTE: sometimes 'type' can be inferred at considerable code cost, error is better

if (nargin < 3) || isempty(type)	
	error('Action type is required.');
end

if ~is_action_type(type)
	error('Unrecognized action type.');
end

%-------------------------------
% SETUP
%-------------------------------

%--
% get callback context
%--

% NOTE: menu is not 'control' but this works

callback = get_callback_context(obj, 'pack');

%--
% get action extension
%--

[ext, ix, context] = get_browser_extension([type, '_action'], callback.par.handle, callback.control.name);
		
if isempty(ext)
	return;
end 

%--
% get action targets
%--

targets = get_action_target(type, callback);

if isempty(targets)
	return;
end

%--
% append action context
%--

% NOTE: extensions could declare context fields required and context could be compiled

context.type = type;

context.target = targets;

context.callback = callback;

%-------------------------------
% DISPATCH ACTION
%-------------------------------

%--
% edit parameters through dialog if needed
%--

% NOTE: the developer test makes sure we can always access the developer menus

if ~isempty(ext.fun.parameter.control.create) || xbat_developer
	
	%--
	% present dialog
	%--
	
	out = action_dialog(targets, ext, ext.parameter, context);

	if ~strcmp(out.action, 'ok')
		return;
	end
	
	%--
	% update and compile parameters if needed
	%--
	
	if ~isempty(out.values)
		
		ext.parameter = struct_update(ext.parameter, out.values);
		
		if ~isempty(ext.fun.parameter.compile)
			try
				[ext.parameter, context] = ext.fun.parameter.compile(ext.parameter, context);
			catch 
				extension_warning(ext, 'Parameter compilation failed.', lasterror);
			end
		end
		
		% NOTE: makes sure context extension is not stale, the system does not guarantee this
		
		context.ext = ext;
		
	end
	
	%--
	% store action state in browser
	%--
	
	set_browser_extension(callback.par.handle, ext);
	
end

%--------------------
% START
%--------------------

%--
% create waitbar
%--

% NOTE: the default extension behavior is to have a waitbar

if ext.waitbar
	
	pal = action_waitbar(context); 
	
	% NOTE: the key thing here is the number of operations
	
	progress.sequence = linspace(0, 1, ...
		length(targets) + ~isempty(ext.fun.prepare) + ~isempty(ext.fun.conclude) ...
	);
	
	progress.index = 1;
	
end

%--
% start time of action execution
%--

started = datestr(now); start = clock;

%--------------------
% PREPARE
%--------------------

if ~isempty(ext.fun.prepare)
	
	%--
	% indicate we are preparing
	%--
	
	waitbar_update(pal, 'PROGRESS', 'message', ['Preparing ...']);

	%--
	% try to prepare
	%--
	
	try
		[output, context] = ext.fun.prepare(ext.parameter, context); status = 'done';
	catch
		output = lasterror; status = 'failed'; extension_warning(ext, 'Prepare failed.', lasterror);
	end
	
	prepare = action_result(status, 'prepare', output, '', start);
	
	%--
	% update with result of prepare
	%--
	
	action_waitbar_update(pal, progress.sequence(progress.index), [], type); 
	
	progress.index = progress.index + 1;
	
	% NOTE: returning orphans the waitbar, so we can see that prepare failed
	
	if strcmp(prepare.status, 'failed');
		return;
	end
	
end

%--------------------
% PERFORM ACTION
%--------------------

%--
% get required state for event action
%--

switch type
	
	case 'event', par = callback.par; data = get_browser(par.handle);
		
end

%--
% loop over action targets
%--

status = 'done';

for k = 1:length(targets)

	%--
	% cancel on closing of waitbar
	%--
	
	% NOTE: this is not working right now
	
	if ~ishandle(pal) 
		status = 'cancel'; break;
	end
	
	%--
	% update waitbar while we get actual target from targets
	%--
	
	switch type
	
		case 'event'
		
			[target, context.log] = get_str_event(par.handle, targets{k}, data);
			
			target_name = get_action_target_name(target, type);
			
			waitbar_update(pal, 'PROGRESS', ... 
				'message', ['Reading ', target_name, ' ...'] ...
			);
			
			% TODO: this should be optional, not all actions want this up front
			
			target = event_sound_read(target, context.sound);

		case 'sound'
			
			target = targets(k);
            
            target = sound_attribute_update(target, context.library);

			target_name = get_action_target_name(target, type);
			
		case 'log'
			
			waitbar_update(pal, 'PROGRESS', ... 
				'message', ['Loading ', targets{k}, ' ...'] ...
			);
		
			target = get_target_log(targets{k}, context);
			
			target_name = targets{k};
			
	end
	
	%--
	% indicate processing
	%--
	
	waitbar_update(pal, 'PROGRESS', 'message', ['Processing ', target_name, ' ...']);

	%--
	% perform action on target
	%--
	
	[result(k), context] = perform_action(target, ext, ext.parameter, context);
	
	%--
	% update waitbar results
	%--
	
	% TODO: implement interrupt behavior using waitbar closing
	
	if ext.waitbar && ishandle(pal)
		
		action_waitbar_update(pal, progress.sequence(progress.index), result(k), type); 
		
		progress.index = progress.index + 1;
		
	end
		
end

%--------------------
% CONCLUDE
%--------------------

if ~isempty(ext.fun.conclude)
	
	%--
	% indicate we are concluding
	%--
	
	waitbar_update(pal, 'PROGRESS', 'message', ['Concluding ...']);

	%--
	% try to conclude
	%--
	
	try
		output = ext.fun.conclude(ext.parameter, context); status = 'done';
	catch	
		output = lasterror; status = 'failed'; extension_warning(ext, 'Conclude failed.', lasterror);	
	end
	
	conclude = action_result(status, 'conclude', output, '', start);
	
	%--
	% update with result of prepare
	%--
	
	action_waitbar_update(pal, progress.sequence(progress.index), [], type); 
	
	progress.index = progress.index + 1;
	
	if strcmp(conclude.status, 'failed');
		set_control(pal, 'close_on_completion', 'value', 0);
	end
	
end

%--------------------
% OUTPUT RESULT
%--------------------

% NOTE: 'perform_action' wraps action instance info, wrap again to add action info

last_action.name = ext.name;

% NOTE: consider using when we implement interrupt behavior

last_action.status = status;

last_action.started = started;

elapsed = sum([result.elapsed]);

last_action.elapsed = elapsed;

last_action.result = result;

% NOTE: a partial content assignment could happen in the loop

assignin('base', 'last_action', last_action);

%-------------------------------------
% FINISH
%-------------------------------------

%--
% update xbat palette if needed
%--

switch ext.subtype
	
	case 'event_action'
		% NOTE: this is probably going to update an event palette

	% TODO: we should fix the selection preservation behavior for listboxes
	
	case 'log_action'
		xbat_palette('find_logs');
		
	case 'sound_action'
		xbat_palette('find_sounds');

end

%--
% indicate completion in waitbar
%--

if ext.waitbar && ishandle(pal)
	
	%--
	% close waitbar if needed
	%--
	
	if get_control(pal, 'close_after_completion', 'value')
		close(pal); return;
	end
		
	%--
	% present completion message
	%--

	if elapsed > 2
		time = sec_to_clock(elapsed);
	else 
		time = [num2str(elapsed, 4), ' sec'];
	end

	message = [integer_unit_string(numel(targets), type), ' processed in ', time];

	waitbar_update(pal, 'PROGRESS', ...
		'message', message ...
	);
	
end

