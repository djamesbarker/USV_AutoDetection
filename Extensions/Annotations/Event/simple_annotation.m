function out = simple_annotation(mode, varargin)

% simple_annotation - simple code and notes annotation
% ----------------------------------------------------
%
%  annotation = simple_annotation('create')
% description = simple_annotation('describe');
%
%         log = simple_annotation('batch',log,ix,annotation)
%       event = simple_annotation('batch',event,annotation)
%
%        flag = simple_annotation('selection',h)
%             = simple_annotation('events',h,m,ix)
%
%           g = simple_annotation('menu',h,m,ix,data)
%             = simple_annotation('display',h,m,ix,data)
%
% Input:
% ------
%  log - input log structure
%  event - input event array
%  h - handle to parent figure
%  m - index of log
%  ix - index of events in log
%
% Output:
% -------
%  annotation - annotation structure
%  log - log structure
%  event - event array
%  flag - update indicator
%  g - handles to objects created

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

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 689 $
% $Date: 2005-03-09 22:14:37 -0500 (Wed, 09 Mar 2005) $
%--------------------------------

% TODO: add rating field, at the moment this will probably be implemented
% as an integer slider or a text popup menu

%--------------------------------------------------------
% SET DEFAULT MODE
%--------------------------------------------------------

if (~nargin)
	mode = 'create';
end

%--------------------------------------------------------
% CREATE ANNOTATION DESCRIPTION
%--------------------------------------------------------

persistent DESCRIPTION_PERSISTENT;

if (isempty(DESCRIPTION_PERSISTENT))
	DESCRIPTION_PERSISTENT = annotation_describe;
end

description = DESCRIPTION_PERSISTENT;

%--------------------------------------------------------
% CREATE EMPTY ANNOTATION
%--------------------------------------------------------

%--
% create annotation structure
%--

annotation = annotation_create;

%--
% set name of annotation
%--

annotation.name = description.name;

%--
% create function handle to main annotation function
%--

persistent FUNCTION_HANDLE_PERSISTENT;

if (isempty(FUNCTION_HANDLE_PERSISTENT))
	FUNCTION_HANDLE_PERSISTENT = eval(['@' mfilename]);
end

annotation.fun = FUNCTION_HANDLE_PERSISTENT;

%--
% set annotation default value
%--

persistent PERSISTENT_VALUE;

if (isempty(PERSISTENT_VALUE))
	PERSISTENT_VALUE = value_fun('create');
end

annotation.value = PERSISTENT_VALUE;

%--------------------------------------------------------
% COMPUTE ACCORDING TO MODE
%--------------------------------------------------------

switch (mode)

	%--------------------------------------------------------
	%--------------------------------------------------------
	% OUTPUT SAMPLE ANNOTATION
	%--------------------------------------------------------
	%--------------------------------------------------------

	case ('create')

		out = annotation;

		%--------------------------------------------------------
		%--------------------------------------------------------
		% OUTPUT ANNOTATION DESCRIPTION
		%--------------------------------------------------------
		%--------------------------------------------------------

	case ('describe')

		out = description;

		%--------------------------------------------------------
		%--------------------------------------------------------
		% LOG SELECTION WITH ANNOTATION
		%--------------------------------------------------------
		%--------------------------------------------------------

		% NOTE: this only happens in sound browser

	case ('selection')

		%--
		% rename input
		%--

		h = varargin{1};

		%--
		% get userdata and selection event
		%--

		data = get(h,'userdata');

		event = data.browser.selection.event;

		%--
		% ensure non-empty author
		%--

		author = author_validate(data.browser.author);

		if (isempty(author))
			out = 0;
			return;
		else
			data.browser.author = author;
		end

		%--
		% setup input dialog for annotation scheme
		%--

		title_str = 'Selection';

		LOGS = file_ext(struct_field(data.browser.log,'file'));

		[value,author,log] = value_edit( ...
			description, ...
			title_str, ...
			PERSISTENT_VALUE, ...
			author, ...
			{LOGS{:}, data.browser.log_active} ...
			);

		%--
		% set annotation author and update browser author
		%--

		annotation.author = author;
		data.browser.author = author;

		%--
		% append this annotation to current event annotation array if needed
		%--

		if (isempty(value))

			out = 0;
			return;

		else

			%--
			% set annotation value and output flag
			%--

			out = 1;
			annotation.value = value;

			%--
			% update persistent value
			%--

			PERSISTENT_VALUE = value;

			%--
			% get log index and update active log
			%--

			m = find(strcmp(LOGS,log));

			data.browser.log_active = m;

			set(data.browser.log_menu.active,'check','off');
			set(data.browser.log_menu.active(m),'check','on');

			%--
			% append annotation to annotation array
			%--

			len = length(event.annotation);

			if ((len == 1) & isempty(event.annotation(1).name))
				len = 0;
			end

			event.annotation(len + 1) = annotation;

			%--
			% add id to event and update current id for log
			%--

			id = data.browser.log(m).curr_id;

			event.id = id;
			data.browser.log(m).curr_id = id + 1;

			%--
			% put annotated event into log
			%--

			len = length(data.browser.log(m).event);

			if ((len == 1) & isempty(data.browser.log(m).event(1).id))
				ix = 1;
			else
				ix = len + 1;
			end

			data.browser.log(m).event(ix) = event;
			data.browser.log(m).length = ix;

			%--
			% update save state of log
			%--

			if (data.browser.log(m).autosave)
				data.browser.log(m).saved = 1;
			else
				data.browser.log(m).saved = 0;
			end

			%--
			% update userdata
			%--

			set(h,'userdata',data);

			%--
			% update event display along with menu update
			%--

			% display event before deleting the selection display

			delete(findall(h,'tag',[int2str(m) '.' int2str(ix)]));

			event_view('sound',h,m,ix);

			delete(data.browser.selection.handle);

			drawnow;

			%--
			% turn off selection related options
			%--

			tmp = data.browser.edit_menu.edit;

			set(get_menu(tmp,'Cut Selection'),'enable','off');
			set(get_menu(tmp,'Copy Selection'),'enable','off');
			set(get_menu(tmp,'Log Selection ...'),'enable','off');
			set(get_menu(tmp,'Delete Selection'),'enable','off');

			%--
			% save log if needed
			%--

			if (data.browser.log(m).autosave)
				log_save(data.browser.log(m));
			end

		end

		%--------------------------------------------------------
		%--------------------------------------------------------
		% BATCH OPERATIONS
		%--------------------------------------------------------
		%--------------------------------------------------------

		% NOTE: these are meant for the command line

	case ('batch')

		switch (length(varargin))

			%--------------------------------------------------------
			% BATCH ANNOTATE EVENT SEQUENCE
			%--------------------------------------------------------

			case (2)

				%--
				% rename input
				%--

				event = varargin{1};
				annotation = varargin{2};

				%--
				% check name of annotation to add
				%--

				if (~strcmp(annotation.name,description.name))

					disp(' ');
					error(['Input annotation name is ''' annotation.name ''' not ''' description.name '''.']);

					out = [];
					return;

				end

				%--
				% get current date string
				%--

				curr = now;

				%--
				% add or update annotation in event sequence
				%--

				for k = 1:length(event)

					%--
					% get index of annotation
					%--

					tmp = struct_field(event(k).annotation,'name');
					ixa = find(strcmp(tmp,description.name));

					%--
					% add annotation
					%--

					if (isempty(ixa))

						len = length(event(k).annotation);
						if ((len == 1) & isempty(event(k).annotation(1).name))
							len = 0;
						end

						annotation.created = curr;
						annotation.modified = [];

						event(k).annotation(len + 1) = annotation;

						%--
						% update annotation
						%--

					else

						annotation.created = event(k).annotation(ixa).created;
						annotation.modified = curr;

						event(k).annotation(ixa) = annotation;

					end

				end

				%--
				% output event sequence
				%--

				out = event;

				%--------------------------------------------------------
				% BATCH ANNOTATE EVENTS IN LOG (THIS MAY BE USED WITHIN THE BROWSERS)
				%--------------------------------------------------------

			case (3)

				%--
				% rename input
				%--

				log = varargin{1};
				ix = varargin{2};
				annotation = varargin{3};

				%--
				% check event indices
				%--

				if (isempty(ix))

					ix = 1:log.length;

				else

					if (any(ix < 1) | any(ix > log.length))

						disp(' ');
						error('Some desired event indices are out of range.');

						% note that in the case of batch operation we output an
						% empty array and in the browser related operations we
						% output a success flag

						out = [];

						return;

					end

				end

				%--
				% check name of annotation to add
				%--

				if (~strcmp(annotation.name,description.name))

					disp(' ');
					error(['Input annotation name is ''' annotation.name ''' not ''' description.name '''.']);
					disp(' ');

					out = [];
					return;

				end

				%--
				% get current date string
				%--

				curr = now;

				%--
				% add or update annotation in log events
				%--

				for k = 1:length(ix)

					%--
					% get index of annotation
					%--

					tmp = struct_field(log.event(ix(k)).annotation,'name');
					ixa = find(strcmp(tmp,description.name));

					%--
					% add annotation
					%--

					if (isempty(ixa))

						len = length(log.event(ix(k)).annotation);
						if ((len == 1) & isempty(log.event(ix(k)).annotation(1).name))
							len = 0;
						end

						annotation.created = curr;
						annotation.modified = [];

						log.event(ix(k)).annotation(len + 1) = annotation;

						%--
						% update annotation
						%--

					else

						annotation.created = log.event(ix(k)).annotation(ixa).created;
						annotation.modified = curr;

						log.event(ix(k)).annotation(ixa) = annotation;

					end

				end

				%--
				% output log
				%--

				out = log;

		end

		%--------------------------------------------------------
		%--------------------------------------------------------
		% ADD OR EDIT ANNOTATION
		%--------------------------------------------------------
		%--------------------------------------------------------

	case ('events')

		%--
		% rename input
		%--

		h = varargin{1};
		m = varargin{2};
		ix = varargin{3};

		%--
		% get userdata
		%--

		data  = get(h,'userdata');

		%--
		% handle log browser get parent userdata
		%--

		% when the current figure is the same as the userdata figure the call
		% has been initiated from the sound browser

		if (gcf == h)
			flag = 0;
		else
			flag = 1;
		end

		%--------------------------------------------------------
		% ADD OR EDIT ANNOTATION OF SINGLE EVENT
		%--------------------------------------------------------

		if (length(ix) == 1)

			%--
			% get event and log filename
			%--

			event = data.browser.log(m).event(ix);

			file = file_ext(data.browser.log(m).file);

			%--------------------------------------------------------
			% ADD ANNOTATION
			%--------------------------------------------------------

			ixa = find(strcmp(struct_field(event.annotation,'name'),description.name));

			if (isempty(ixa))

				title_str = [file ' # ' int2str(event.id)];

				[value,author] = value_edit( ...
					description, ...
					title_str, ...
					PERSISTENT_VALUE, ...
					data.browser.author ...
					);

				%--
				% set annotation author and update browser author
				%--

				annotation.author = author;
				data.browser.author = author;

				%--
				% append this annotation to current event annotation array if needed
				%--

				if (isempty(value))

					out = 0;
					return;

				else

					out = 1;

					%--
					% set annotation value and output flag
					%--

					annotation.value = value;

					%--
					% append annotation to annotation array
					%--

					len = length(event.annotation);

					if ((len == 1) & isempty(event.annotation(1).name))
						len = 0;
					end

					event.annotation(len + 1) = annotation;

					%--
					% put annotated event into log
					%--

					data.browser.log(m).event(ix) = event;

				end

				%--------------------------------------------------------
				% EDIT ANNOTATION
				%--------------------------------------------------------

			else

				%--
				% setup default value in input dialog using current value
				%--

				title_str = [file ' # ' int2str(event.id)];

				[value,author] = value_edit( ...
					description, ...
					title_str, ...
					event.annotation(ixa).value, ...
					event.annotation(ixa).author ...
					);

				%--
				% set annotation author and update browser author
				%--

				event.annotation(ixa).author = author;
				data.browser.author = author;

				%--
				% append this annotation to current event annotation array if needed
				%--

				if (isempty(value))

					out = 0;
					return;

				else

					out = 1;

					%--
					% set annotation value and output flag
					%--

					event.annotation(ixa).value = value;

					%--
					% update annotation and annotation modification date
					%--

					curr = now;
					event.annotation(ixa).modified = curr;

					%--
					% put annotated event into log
					%--

					data.browser.log(m).event(ix) = event;

				end

			end

			%--
			% update save state of log
			%--

			if (data.browser.log(m).autosave)
				data.browser.log(m).saved = 1;
			else
				data.browser.log(m).saved = 0;
			end

			%--
			% update userdata
			%--

			set(h,'userdata',data);

			%--
			% update event display
			%--

			if (flag == 1)

				%--
				% log browser display update for a single event
				%--

				%--
				% delete previous event display objects
				%--

				% we do this object type delete because the axes are tagged as
				% well and we do not need to remove these

				type = {'uimenu','uicontextmenu','line','patch','text'};

				for k = 1:length(type)
					delete(findall(gcf,'tag',[int2str(m) '.' int2str(ix)],'type',type{k}));
				end

				%--
				% rebuild event display and selection
				%--

				event_view('log',gcf,m,ix);
				event_bdfun(gcf,m,ix);

				drawnow;

			else

				%--
				% sound browser display update for a single event
				%--

				%--
				% delete previous event display objects
				%--

				delete(findall(h,'tag',[int2str(m) '.' int2str(ix)]));

				%--
				% rebuild event display and selection
				%--

				event_view('sound',h,m,ix);
				event_bdfun(h,m,ix);

				drawnow;

			end

			%--
			% save log if needed
			%--

			if (data.browser.log(m).autosave)
				log_save(data.browser.log(m));
			end

			%--------------------------------------------------------
			% INTERACTIVE BATCH ADD/EDIT ANNOTATION OF LOG
			%--------------------------------------------------------

		else

			%--
			% copy log
			%--

			log = data.browser.log(m);

			%--
			% check event indices
			%--

			if (any(ix < 1) | any(ix > log.length))

				disp(' ');
				error('Some desired event indices are out of range.');

				out = 0;
				return;

			end

			%--
			% setup default value in input dialog using current value
			%--

			file = file_ext(log.file);

			% this title should be set to something more descriptive

			% 		title_str = [file ' Selected'];
			title_str = file;

			[value,author] = value_edit( ...
				description, ...
				title_str, ...
				PERSISTENT_VALUE, ...
				data.browser.author ...
				);

			%--
			% append edit this annotation to events in log if needed
			%--

			if (isempty(value))

				out = 0;
				return;

			else

				out = 1;

				%--
				% set value
				%--

				annotation.value = value;

				%--
				% set annotation author and update browser author
				%--

				annotation.author = author;
				data.browser.author = author;

				%--
				% get current date time and update annotation date
				%--

				curr = now;

				%--
				% create waitbar
				%--

				hw = wait_bar(0,'');
				set(hw,'name',[description.name '  -  ' file]);

				start_time = clock;

				%--
				% add or update annotation in log events
				%--

				nix = length(ix);

				for k = 1:nix

					%--
					% get index of annotation
					%--

					tmp = struct_field(log.event(ix(k)).annotation,'name');
					ixa = find(strcmp(tmp,description.name));

					%--
					% add annotation
					%--

					if (isempty(ixa))

						len = length(log.event(ix(k)).annotation);
						if ((len == 1) & isempty(log.event(ix(k)).annotation(1).name))
							len = 0;
						end

						annotation.created = curr;
						annotation.modified = '';

						log.event(ix(k)).annotation(len + 1) = annotation;

						%--
						% update annotation
						%--

					else

						annotation.created = log.event(ix(k)).annotation(ixa).created;
						annotation.modified = curr;

						log.event(ix(k)).annotation(ixa) = annotation;

					end

					%--
					% update waitbar
					%--

					if (~mod(k,10))
						waitbar((k / nix),hw, ...
							['Events Processed: ' int2str(k) ', Elapsed Time: ' ...
							num2str(etime(clock,start_time),'%5.2f')] ...
							);
					end

				end

			end

			%--
			% indicate that we are updating and saving log
			%--

			waitbar(1,hw, ...
				['Updating and saving log ''' file ''' ...'] ...
				);

			%--
			% put log copy back into userdata
			%--

			data.browser.log(m) = log;

			%--
			% update save state of log
			%--

			if (data.browser.log(m).autosave)
				data.browser.log(m).saved = 1;
			else
				data.browser.log(m).saved = 0;
			end

			%--
			% update userdata
			%--

			set(h,'userdata',data);

			%--
			% save log if needed
			%--

			if (data.browser.log(m).autosave)
				log_save(data.browser.log(m));
			end

			%--
			% close waitbar
			%--

			delete(hw);

			%--
			% update event display
			%--

			if (flag)

				% this is not implemented yet

				% 			log_browser_display(h,'events');

			else

				%--
				% sound browser event display update for multiple events
				%--

				browser_display(h,'events');

			end

		end

		%--------------------------------------------------------
		%--------------------------------------------------------
		% DISPLAY ANNOTATION AS CONTEXT MENU OR GRAPHIC
		%--------------------------------------------------------
		%--------------------------------------------------------

	case ({'menu','display'})

		%--
		% rename input
		%--

		h = varargin{1}; 
		m = varargin{2}; 
		ix = varargin{3};

		%--
		% get userdata if needed
		%--

		if (length(varargin) > 3)
			data = varargin{4};
		else
			data = get(h,'userdata');
		end

		%--
		% handle both sound and log browser display
		%--

		if (~isempty(data.browser.parent))

			flag_log = 1;

			%--
			% get parent handle and update data
			%--

			g = h;
			h = data.browser.parent;
			data = get(h,'userdata');

		else

			flag_log = 0;

		end

		%--
		% get event and log filename
		%--

		% NOTE: this is to solve the active detection display
		
		if (~isempty(m))
			
			event = data.browser.log(m).event(ix);

			file = file_ext(data.browser.log(m).file);
			
		else
			
			event = data.browser.active_detection_log.event(ix);
			
		end

		%--
		% check for existence of annotation
		%--

		ixa = find(strcmp(struct_field(event.annotation,'name'),description.name));

		if (isempty(ixa))
			out = [];
			return;
		end

		%--
		% compute depending on display mode
		%--

		switch (mode)

			%--------------------------------------------------------
			% DISPLAY ANNOTATION INFORMATION IN CONTEXTUAL MENU
			%--------------------------------------------------------

			case ('menu')

				%--
				% get event display parent handle
				%--

				if (~flag_log)
					g = findobj(h,'type','patch','tag',[int2str(m) '.' int2str(ix)]);
				else
					g = findobj(g,'type','axes','tag',[int2str(m) '.' int2str(ix)]);
					g = findobj(g,'type','image');
				end

				if (isempty(g))

					out = [];
					return;

				else

					%--
					% get contextual menu of parent
					%--

					g = get(g,'uicontextmenu');

					g = get_menu(g,'Annotation');

					%--
					% create annotation scheme menu and edit option menu
					%--

					mg = menu_group(g,'',{description.name,'Edit ...'});

					tmp = functions(event.annotation(ixa).fun);

					tmp = tmp.function;

					set(mg(2),'callback', ...
						[tmp '(''events'',' int2str(h) ',' int2str(m) ',' int2str(ix) ');']);

					if (get(mg(1),'position') > 1)
						set(mg(1),'separator','on');
					end

					%--
					% annotation information display menu
					%--

					out = annotation_menu(mg(1),m,event,ixa,description,data);

					%--
					% add parent menu handles to output
					%--

					out = [mg, out];

				end

				%--------------------------------------------------------
				% DISPLAY ANNOTATION GRAPHICALLY
				%--------------------------------------------------------

			case ('display')

				%--
				% annotation information graphical display
				%--

				out = annotation_display(h,m,event,ixa,description,data);

				%--
				% tag objects with log and event indices string
				%--

				if (~isempty(m))
					set(out,'tag',[int2str(m) '.' int2str(ix)]);
				else
					tag = ['ACTIVE_DETECTION.' int2str(ix)];
					set(out,'tag',tag);
				end	

		end

end


%--------------------------------------------------------
%  EDITABLE SUB-FUNCTIONS FOR ANNOTATION
%--------------------------------------------------------

%--------------------------------------------------------
% ANNOTATION_DESCRIPTION
%--------------------------------------------------------

function description = annotation_describe

% annotation_describe - create annotation description
% ---------------------------------------------------
%
% description = annotation_describe
%
% Output:
% -------
%  description - annotation description
%
%    .name - name of annotation
%    .value - value description

%--
% set name of annotation
%--

description.name = 'Simple';

%--
% set value description
%--

description.value = value_fun('describe');


%--------------------------------------------------------
%  VALUE_FUN
%--------------------------------------------------------

function varargout = value_fun(mode,varargin)

% value_fun - value handling functions
% ------------------------------------
%
%  value = value_fun('describe')
%  value = value_fun('create')
%
%  value = value_fun('pack',ans)
%    ans = value_fun('unpack',value)
%
% Input:
% ------
%  ans - value cell array
%  value - value structure
%
% Output:
% -------
%  value - value structure
%
%  value - value description
%
%    .field - field names
%    .type - field types
%    .default - default field value
%    .line - display size of input fields
%    .tip - field tips
%    .menu - menu fields
%    .separator - field separators in menu
%
%  ans - value in cell array

%--
% set mode
%--

if (~nargin)
	mode = 'create';
end

%--
% compute depending on mode
%--

switch (mode)

	%--
	% create value structure with default value
	%--

	case ('create')

		%--
		% create value structure
		%--

		value.code = '';
		value.notes = '';

		%--
		% output value structure
		%--

		varargout{1} = value;

		%--
		% create value description
		%--

	case ('describe')

		%--
		% value field names
		%--

		value.field = { ...
			'Code', ...
			'Notes' ...
			};

		%--
		% value structure fields
		%--

		value.struct = { ...
			'code', ...
			'notes' ...
			};

		%--
		% value field types
		%--

		value.type = { ...
			'', ...
			'' ...
			};

		%--
		% value field default value
		%--

		value.default = { ...
			'', ...
			'' ...
			};

		%--
		% value field input display size
		%--

		value.line = [ ...
			1, 40; ...
			4 ,40 ...
			];

		%--
		% value field tips
		%--

		value.tip = { ...
			'Code string for event', ...
			'Textual notes for event' ...
			};

		%--
		% value menu fields and separators
		%--

		value.menu = { ...
			'Code', ...
			'Notes' ...
			};

		value.separator = [];

		%--
		% output value description
		%--

		varargout{1} = value;

		%--
		% pack value cell array in structure
		%--

	case ('pack')

		%--
		% rename input
		%--

		ans = varargin{1};

		%--
		% create and update value structure
		%--

		value.code = ans{1};
		value.notes = ans{2};

		%--
		% output value structure
		%--

		varargout{1} = value;

		%--
		% unpack value structure to cell array
		%--

	case ('unpack')

		%--
		% rename input
		%--

		value = varargin{1};

		%--
		% unpack value value into cell array
		%--

		ans{1} = value.code;
		ans{2} = value.notes;

		%--
		% output value cell array
		%--

		varargout{1} = ans;

end


%--------------------------------------------------------
%  VALUE_EDIT (DEFAULT)
%--------------------------------------------------------

function [value,author,log] = value_edit(description,title,value,author,logs)

% value_edit - description generated edit dialog for value
% ---------------------------------------------------------
%
% [value,log,author] = value_edit(description,title,value,author,logs)
%
% Input:
% ------
%  description - annotation description
%  title - title for edit dialog
%  value - input value
%  logs - open log names
%  author - current author
%
% Output:
% -------
%  value - value structure
%  author - author of value selection

%--
% get value name and value description
%--

name = description.name;

description = description.value;

%--
% unpack parameters into cell array
%--

ans = value_fun('unpack',value);

%--
% update dialog default value using input parameters
%--

n = length(description.default);

for k = 1:n

	%--
	% update according to input type
	%--

	switch (class(description.default{k}))

		%--
		% editable text box
		%--

		case ('char')

			description.default{k} = ans{k};

			%--
			% slider input
			%--

		case ('double')

			description.default{k}(1) = ans{k};

			%--
			% popup or listbox input
			%--

		case ('cell')

			ix = find(strcmp(description.default{k},ans{k}));

			if (~isempty(ix))
				description.default{k}{end} = ix;
			else
				description.default{k}{end} = 1;
			end

	end

end

%--
% compute depending on input arguments
%--

if (nargin > 4)

	%--
	% add log and author fields to input dialog
	%--

	description.field{n + 1} = 'Log';
	description.default{n + 1} = logs;
	description.line(n + 1,:) = [1,26];
	description.tip{n + 1} = 'Log to append';

	description.field{n + 2} = 'Author';
	description.default{n + 2} = author;
	description.line(n + 2,:) = [1,26];
	description.tip{n + 2} = 'Author of annotation';

	%--
	% build value editing input dialog
	%--

	ans = input_dialog( ...
		description.field, ...
		[name '  -  ' title], ...
		description.line, ...
		description.default, ...
		description.tip ...
		);

	%--
	% output edited parameters if needed
	%--

	if (isempty(ans))

		value = [];
		author = '';
		log = '';

	else

		author = author_validate(ans{n + 2});

		if (isempty(author))
			value = [];
			log = '';
		else
			value = value_fun('pack',ans(1:n));
			log = ans{n + 1};
		end

	end

else

	%--
	% add author field to input dialog
	%--

	description.field{n + 1} = 'Author';
	description.default{n + 1} = author;
	description.line(n + 1,:) = [1,26];
	description.tip{n + 1} = 'Author of annotation';

	%--
	% build value editing input dialog
	%--

	ans = input_dialog( ...
		description.field, ...
		[name '  -  ' title], ...
		description.line, ...
		description.default, ...
		description.tip ...
	);

	%--
	% output edited parameters if needed
	%--

	if (isempty(ans))

		value = [];
		author = '';
		log = '';

	else

		value = value_fun('pack',ans(1:n));
		author = author_validate(ans{n + 1});
		log = '';

	end

end


%--------------------------------------------------------
%  ANNOTATION_MENU (DEFAULT)
%--------------------------------------------------------

function g = annotation_menu(h,m,event,ixa,description,data)

% annotation_menu - create description generated menu display
% ------------------------------------------------------------
%
% g = annotation_menu(h,m,event,ixa,description,data)
%
% Input:
% ------
%  h - handle to parent
%  m - log index
%  event - measured event
%  ixa - annotation index in event
%  description - annotation description
%  data - figure userdata context
%
% Output:
% -------
%  g - handles to created menus

%--
% unpack annotation structures to cell arrays
%--

value = value_fun('unpack',event.annotation(ixa).value);

%--
% create value menu
%--

name = description.name;

description = description.value;

n = length(description.menu);

L = cell(1,n);
j = 1;

for k = 1:n

	%--
	% get field index
	%--

	ixf = find(strcmp(description.field,description.menu{k}));

	%--
	% create menu label depending on value type
	%--

	if (isempty(value{ixf}))

		L{k} = [title_caps(description.field{ixf},'_'), ':  ( NO CODE )'];

	else

		L{k} = [title_caps(description.field{ixf},'_'), ':  '];

		%--
		% display according to value class and type
		%--

		switch (class(value{ixf}))

			%--
			% string value
			%--

			case ('char')

				% NOTE: truncate long strings to length ~32 characters

				if (length(value{ixf}) <= 32)
					L{k} = [L{k} value{ixf}];
				else
					L{k} = [L{k} value{ixf}(1:28) ' ...'];
				end

			%--
			% number value
			%--

			case ('double')

				%--
				% get type of value field
				%--

				type = description.type{ixf};

				%--
				% create menu according to description type
				%--

				switch (type)

					%--
					% datetime and time display
					%--

					case ('datetime')

						tmp = data.browser.grid.time.labels;

						if (strcmp(tmp,'seconds'))
							L{k} = [L{k} num2str(value{ixf})];
						else
							if (data.browser.grid.time.realtime)

								date = datevec(data.browser.sound.realtime);
								time = date(4:6)*[3600,60,1]';
								L{k} = [L{k} sec_to_clock(time + value{ixf})];

							else
								L{k} = [L{k} sec_to_clock(value{ixf})];
							end
						end

					%--
					% time display
					%--
					
					case ('time')

						tmp = data.browser.grid.time.labels;

						if (strcmp(tmp,'seconds'))
							L{k} = [L{k} num2str(value{ixf})];
						else
							L{k} = [L{k} sec_to_clock(value{ixf})];
						end

					%--
					% frequency display
					%--

					case ('freq')

						tmp = data.browser.grid.freq.labels;

						if (strcmp(tmp,'kHz'))
							L{k} = [L{k} num2str(value{ixf} / 1000) ' kHz'];
						else
							L{k} = [L{k} num2str(value{ixf}) ' Hz'];
						end

					%--
					% miscellaneous unit or no unit display
					%--

					otherwise

						if (length(value{ixf}) == 1)

							L{k} = [L{k} num2str(value{ixf},6) ' ' type];

						else

							str = mat2str(value{ixf},6);
							str = strrep(str,' ',', ');
							str = strrep(str,';','; ');
							L{k} = [L{k} str ' ' type];

						end

				end

			%--
			% cell array value (this is not fully supported, currently only strings)
			%--

			case ('cell')

				if (length(value{ixf}) == 1)
					L{k} = [L{k} value{ixf}{1}];
				else
					ixc(j) = ixf;
					M{j} = L{k};
					j = j + 1;
				end

		end

	end

end

L{n + 1} = [name ' Info:'];

%--
% set separators
%--

S = bin2str(zeros(1,n + 3));

for k = 1:length(description.separator)
	S{description.separator(k)} = 'on';
end

S{n + 1} = 'on';

%--
% create menu items with empty callbacks
%--

g1 = menu_group(h,'',L,S);

%--
% disable empty field menus to de-emphasize
%--

for k = 1:length(L)
	
	if (~isempty(findstr(L{k},'( NO CODE )')))
		set(g1(k),'enable','off');
	end
	
end

%--
% add author, creation and modification date information fields
%--

L = { ...
	['Author:  ' event.annotation(ixa).author], ...
	['Created:  ' datestr(event.annotation(ixa).created)] ...
};

if (~isempty(event.annotation(ixa).modified))
	L{3} = ['Modified:  ' datestr(event.annotation(ixa).modified)];
end

S = bin2str(zeros(1,3));

S{2} = 'on';

g2 = menu_group(get_menu(g1,[name ' Info:']),'',L,S);

%--
% put all handles together
%--

g = [g1,g2];

%--
% create submenus for cell arrays if needed (only strings are currently supported)
%--

if (j > 1)

	for k = 1:length(M)
		
		L = cell(0);
		tmp = description{ixc(k)};
		
		for j = 1:length(tmp)
			L{j} = tmp{j};
		end
		
		gk{k} = menu_group(get_menu(h,M{k}),'',L);
		
	end

	%--
	% append submenu handles to other menu handles
	%--

	for k = 1:length(M)
		g = [g, gk{k}];
	end

end


%--------------------------------------------------------
%  ANNOTATION_DISPLAY
%--------------------------------------------------------

function g = annotation_display(h, m, event, ixa, description, data)

% annotation_display - create graphical display of annotation data
% -------------------------------------------------------------
%
% g = annotation_display(h, m, event, ixa, description, data)
%
% Input:
% ------
%  h - handle to figure
%  m - log index
%  event - annotated event
%  ixa - annotation index
%  description - annotation description
%  data - figure userdata
%
% Output:
% -------
%  g - handles to created objects

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 689 $
% $Date: 2005-03-09 22:14:37 -0500 (Wed, 09 Mar 2005) $
%--------------------------------

% NOTE: this function uses the log index to get the log display color, this
% input could also be a color.

% NOTE: the parent handle is not used at all

%---------------------------------------------
% INITIALIZATION
%---------------------------------------------

% NOTE: this is to solve the active detection problem

if isempty(m)
	rgb = 0 * ones(1,3); active_flag = 1;
else
	rgb = data.browser.log(m).color; active_flag = 0;
end

%--
% get code string if available
%--

str = event.annotation(ixa).value.code;

if isempty(str)
	str = '( NO CODE )';
end

%--
% compute text position
%--

x = sum(event.time) / 2;

% TODO: text padding takes up half of the display time, make this faster

pad = get(data.browser.axes(1), 'ylim'); 

pad = 0.0125 * pad(2);

if strcmp(data.browser.grid.freq.labels, 'Hz')
	y = event.freq(2) + pad;
else
	y = (event.freq(2) / 1000) + pad;
end

%--
% get event display axes
%--

% NOTE: this will only work on the sound display

% TODO: display axes should be a part of the input, this part of the system needs updating

dax = data.browser.axes(find(get_channels(data.browser.channels) == event.channel));

% NOTE: this is probably more robust but slower

% dax = findobj(data.browser.axes, 'tag', int2str(event.channel));

%---------------------------------------------
% DISPLAY CODE TEXT
%---------------------------------------------

if active_flag
	
	g(1) = text( ...
		'parent', dax, ...
		'position', [x, y, 0], ...
		'clipping', 'off', ...
		'string', str, ...
		'margin', 2, ...
		'edgecolor', [1 1 1], ...
		'linewidth', 1, ...
		'linestyle', '-', ...
		'color', rgb, ...
		'HorizontalAlignment', 'left', ...
		'VerticalAlignment', 'middle' ...
	);

else

	g = text( ...
		'parent', dax, ...
		'position', [x, y, 0], ...
		'clipping', 'off', ...
		'string', str, ...
		'color', rgb, ...
		'HorizontalAlignment', 'left', ...
		'VerticalAlignment', 'middle' ...
	);

end
		
% NOTE: add mode to the input of the view function and to the annotate menu

% TODO: make other modes available

mode = 'Diagonal';

switch mode
	
	case 'Horizontal'
		set(g, 'rotation', 0);

	case 'Diagonal'
		set(g, 'rotation', 45);
		
	case 'Vertical'
		set(g, 'rotation', 90);

end

%--
% add highlight to display text
%--

% TODO: add callback to this highlight to enable editing

text_highlight(g(1));

