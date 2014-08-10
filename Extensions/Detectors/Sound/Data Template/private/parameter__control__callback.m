function result = parameter__control__callback(callback, context)

% DATA TEMPLATE - parameter__control__callback

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

%----------------------------
% SETUP
%----------------------------

%--
% unpack callback
%--

control = callback.control; pal = callback.pal; par = callback.par; 

%--
% set update flags
%--

result.update = 1; update_clip = 1;

%----------------------------
% CALLBACKS
%----------------------------

switch control.name
		
	%----------------------------
	% TAGS
	%----------------------------
		
	case 'code'
		
		result.update = 0;
		
		%--
		% get code and templates
		%--
		
		code = get_control(pal.handle, 'code', 'value');
		
		templates = get_control(pal.handle, 'templates', 'value');
		
		if isempty(templates)
			return;
		end
		
		%--
		% update code of current template
		%--
		
		templates.clip(templates.ix).code = code;
		
		set_control(pal.handle, 'templates', 'value', templates);
		
		%--
		% update template_select
		%--
		
		han = get_control(pal.handle, 'template_select', 'handles');
		
		select_str = get(han.obj, 'string');
		
		select_str{templates.ix} = ['Clip ', int2str(templates.ix), ': ', code];
		
		set(han.obj, 'string', select_str, 'value', templates.ix);
		
	

	%---------------------------------------------------------------
	% TEMPLATE
	%---------------------------------------------------------------
		
	case 'template_select'
		
		result.update = 0;
		
		%--
		% get template string and current templates
		%--
		
		% NOTE: this code depends on the string display used
		
		[g1,str] = control_update([],pal.handle,'template_select');
		
		[g2,value] = control_update([],pal.handle,'templates');
		
		if isempty(value)
			return;
		end
		
		if strcmp(str{1}, '(No Available Templates)')
			return;
		end
		
		%--
		% update current template
		%--
		
		[tok,ignore] = strtok(str{1},':');
		
		ix = round(eval(tok(6:end)));

		value.ix = ix;
		
		ax = findobj(g2,'type','axes');
		
		set(ax,'userdata',value);
		
		%--
		% update code
		%--
		
		% NOTE: it is not clear why the separate line of code is needed
				
		if (isempty(value.clip(ix).code))
			set(findobj(pal.handle,'tag','code','style','edit'),'string','');
		else
			control_update([],pal.handle,'code',value.clip(ix).code);
		end
		
		%--
		% update mode
		%--
		
		g = findobj(control_update([],pal.handle,'template_mode'),'style','popupmenu');
								
		% NOTE: that the codes used for the modes start at zero, they need
		% to be offset by 1 to match the string display
		
		if ~isempty(g)
			set(g,'value',value.clip(ix).mode + 1);
		end
		
	%---------------------------------------------------------------
	% PREVIOUS AND NEXT TEMPLATE
	%---------------------------------------------------------------
	
	case {'previous_template', 'next_template'}
		
		result.update = 0;
		
		%--
		% get template control handles
		%--
		
		g = control_update([],pal.handle,'template_select');
		
		g = findobj(g,'style','popupmenu');
		
		n = length(get(g,'string'));
		
		ix = get(g,'value');
		
		%--
		% update control and execute callback
		%--

		switch (control.name)

			case ('previous_template')

				if (ix == 1)
					return;
				else
					ix = ix - 1;
				end

			case ('next_template')

				if (ix == n)
					return;
				else
					ix = ix + 1;
				end

		end
		
		set(g,'value',ix);
		
		control_callback([],pal.handle,'template_select');
		
	%---------------------------------------------------------------
	% TEMPLATE MODE
	%---------------------------------------------------------------
	
	% NOTE: this is used to set and edit a code for the current template
		
	case 'template_mode'
		
		%--
		% get code and template structure array
		%--
		
		[ignore,mode] = control_update([],pal.handle,'template_mode');
		
		[g,templates] = control_update([],pal.handle,'templates');
		
		% NOTE: return if there are no templates
		
		if isempty(templates)
			return;
		end
		
		%----------------------
		% UPDATE OLD TEMPLATES
		%----------------------
		
		% NOTE: the default mode is 'Keep (Exclusive)' the pre-existing behavior
		
		% NOTE: we are also adding an 'id' field to clips
		
		if ~isfield(templates.clip(1), 'mode')
			
			%--
			% add mode and id to each clip
			%--
			
			for k = 1:length(templates.clip)
				
				templates.clip(k).mode = 1;
				templates.clip(k).id = k;
				
			end
			
			%--
			% set current id
			%--
			
			templates.curr_id = k + 1;
			
		end
		
		%--
		% update mode of current template
		%--
		
		ix = templates.ix;
		
		switch mode{1}
			
			case 'Ignore'
				templates.clip(ix).mode = 0;
				
			case 'Keep (Exclusive)'
				templates.clip(ix).mode = 1;
				
			case 'Keep (Non-Exclusive)'
				templates.clip(ix).mode = 2;
				
			case 'Reject'
				templates.clip(ix).mode = 3;
				
		end
				
		ax = findobj(g, 'type', 'axes');
		
		set(ax, 'userdata', templates);
		
	%---------------------------------------------------------------
	% TEMPLATES
	%---------------------------------------------------------------
		
	case 'templates'

		result.update = 0;
		
		%--
		% handle play clip on double click
		%--
		
		% NOTE: we play on double click, the interval is slower than the default

		ax = findobj(pal.handle,'tag','templates','type','axes');
		
		if double_click(ax, 0.5)
			play_clip(pal.handle);  return;
		end			
		
		%--
		% get templates
		%--
		
		templates = get_control(pal.handle, 'templates', 'value');
		
		if isempty(templates)
			return;
		end
		
		%--
		% update the template select control
		%--
		
		for k = 1:length(templates.clip)
			
			prefix = ['Clip ' int2str(k) ':  '];
			
			if ~isempty(templates.clip(k).code)
				L{k} = [prefix, templates.clip(k).code];
			else
				L{k} = [prefix, '( NO CODE )'];
			end
			
		end
		
		% TODO: update 'set_control' to set the string
		
		han = get_control(pal.handle, 'template_select', 'handles');
		
		set(han.obj, ...
			'string', L, ...
			'value', templates.ix ...
		);		
	
		return;
		
	%---------------------------------------------------------------
	% COPY
	%---------------------------------------------------------------
	
	% NOTE: this is to get extent parameters from selection
	
	case {'copy', 'INTERCEPT_SELECTION_COPY'}
		
		%--
		% return on selection copy if intercept is off
		%--
		
		% TODO: this code does not handle the toggle correctly
		
		if strcmp(control.name, 'INTERCEPT_SELECTION_COPY')
			
			[ignore, value] = control_update([], pal.handle, control.name);
			
			if (value == 0)
				return;
			end
		
		end
		
		%--
		% get selection from parent, return if no selection (this should not happen)
		%--
		
		par = get_field(get(pal.handle, 'userdata'), 'parent');
				
		if isempty(par)
			return;
		end
					
		%--
		% get relevant clip data from parent
		%--
		
		% NOTE: when selection derives from selected event other information may be contained 
		
		data = get(par, 'userdata');
		
		event = data.browser.selection.event;
		
		if isempty(event) || isempty(event.time)
			return;
		end
			
		rate = data.browser.sound.samplerate;
			
		%--
		% get template structure from clip axes
		%--
		
		ax = findobj(pal.handle,'type','axes','tag','templates');
		
		templates = get(ax, 'userdata');
		
		%--
		% compile relevant data to create clip
		%--
		
		% TODO: develop a generic clip structure as basic part of system
		
		clip = clip_create(event, rate, [], '', 2);
		
		%--
		% read enough samples to fully re-generate the event spectrogram (2x event duration)
		%--
		
		clip.data = sound_read( ...
			data.browser.sound, 'time', event.time(1), 2*diff(event.time), event.channel ...
		);
				
		%--
		% update templates based on copy mode
		%--
		
		[ignore, mode] = control_update([], pal.handle, 'copy_mode');
						
		switch lower(mode{1})
			
			%--
			% add new template
			%--
			
			case 'add'
								
				if isempty(templates)
					
					clip.id = 1;
					templates.clip = clip;
					
					templates.ix = 1;
					templates.length = 1;
					templates.curr_id = 2;
					
				else
					
					n = length(templates.clip);
					
					clip.id = templates.curr_id;
					
					% HACK: this resolves a problem dealing with
					% concatenating compiled and new clips!
					
					clip = struct_update(templates.clip(end), clip);
					
					templates.clip(n + 1) = clip;
					
					templates.ix = n + 1;
					templates.length = n + 1;
					templates.curr_id = templates.curr_id + 1;
					
				end
				
			%--
			% replace current template
			%--
			
			% TODO: consider defining the replace behavior differently (as a delete and an add)
			
			case 'replace'
								
				if isempty(templates)
					
					clip.id = 1;
					templates.clip = clip;
					
					templates.ix = 1;
					templates.length = 1;
					templates.curr_id = 2;
					
				else
					
					ix = templates.ix;
					templates.clip(ix) = clip;
					
				end
				
		end
		
		set(ax,'userdata',templates);
		
		%--
		% update the template select control
		%--
		
		for k = 1:length(templates.clip)
			
			if (~isempty(templates.clip(k).code))
				L{k} = ['Clip ' int2str(k) ':  ' templates.clip(k).code];
			else
				L{k} = ['Clip ' int2str(k) ':  ( NO CODE )'];
			end
			
		end
		
		g = control_update([],pal.handle,'template_select');
		
		g = findobj(g,'style','popupmenu');
		
		set(g, ...
			'string',L, ...
			'value', templates.ix ...
		);
	
		%--
		% update edit control
		%--
		
		g = findobj(pal.handle,'tag','code','style','edit');
		
		set(g,'string','');
		
		%--
		% update clip display
		%--
		
		plot_clip(pal.handle);
				
	%----------------------------
	% CORRELATION
	%----------------------------
	
	%--
	% test toggles
	%--
	
	case {'thresh_test', 'deviation_test'}
		
		%--
		% enable or disable related threshold slider
		%--
		
		related = strtok(callback.control.name, '_');

		enable = bin2str(get(callback.obj, 'value'));
		
		set_control(callback.pal.handle, related, 'enable', enable);
		
		update_clip = 0;
		
	%----------------------------
	% MASK
	%----------------------------
	
	%--
	% masking toggle
	%--
	
	case 'mask'

		%--
		% toggle enable state of mask percentile control
		%--
		
		enable = bin2str(get(callback.obj, 'value'));
		
		set_control(callback.pal.handle, 'mask_percentile', 'enable', enable);
				
end

%--
% update clip display if needed
%--

if update_clip

	% NOTE: resolve the use of the function handle input
	
	plot_clip(pal.handle);

end


%-----------------------------------------------------------
% TEMPLATE_SELECT_STRINGS
%-----------------------------------------------------------

function [L, ix] = template_select_strings(templates)

% template_select_strings - create template select strings for control
% --------------------------------------------------------------------
%
% [L, ix] = template_select_strings(templates)
%
% Input:
% ------
%  templates - templates
%
% Output:
% -------
%  L - cell of select strings
%  ix - current template index

%--
% return quickly on no templates
%--

if length(templates.clip)
	L = {'(No Available Templates)'}; ix = 1; return;
end

%--
% build template select strings
%--

for k = 1:length(templates.clip)

	prefix = ['Clip ' int2str(k) ':  '];
	
	if ~isempty(templates.clip(k).code)
		L{k} = [prefix, templates.clip(k).code];
	else
		L{k} = [prefix, '( NO CODE )'];
	end

end

ix = templates.ix;





