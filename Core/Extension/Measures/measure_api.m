function out = measure_api(mode,fun,varargin)

% measure_api - XBAT measure programming interface
% -----------------------------------------------
%
% Definition calls:
% -----------------
%
%  desc = measure_api('describe',fun,h)
%  meas = measure_api('create',fun,h)
%
% Computation calls:
% ------------------
%
%   log = measure_api('batch',fun,log,ix,meas)
% event = measure_api('batch',fun,sound,event,meas)
%  flag = measure_api('events',fun,h,m,ix,meas)
%
% Display calls:
% --------------
%
%     g = measure_api('menu',fun,h,m,ix,data)
%     g = measure_api('display',fun,h,m,ix,data)
%
% Input:
% ------
%  fun - measurement function handles
%  h - handle to parent figure
%  log - log structure
%  ix - indices of events in log
%  meas - measurement structure (contains current parameter)
%  event - event structure array
%  m - index of log
%  data - browser state structure
%
% Output:
% -------
%  desc - description structure
%  meas - measurement structure
%  log - log structure
%  event - event structure array
%  flag - update success indicator
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
% $Revision: 132 $
% $Date: 2004-12-02 15:58:47 -0500 (Thu, 02 Dec 2004) $
%--------------------------------

%--------------------------------------------------------
% SET DEFAULT MODE
%--------------------------------------------------------

if (~nargin)
	mode = 'create';
end

%--
% set context flag for create and describe
%--

if (strcmp(mode,'create') | strcmp(mode,'describe'))
	h = varargin{1};
end

%--------------------------------------------------------
% CREATE MEASUREMENT DESCRIPTION
%--------------------------------------------------------

% desc = feval(fun.describe,h);

desc.name

%--------------------------------------------------------
% CREATE EMPTY MEASUREMENT
%--------------------------------------------------------

%--
% create measurement structure
%--

meas = measurement_create;

%--
% set name, value, and parameter fields of measurement
%--

meas.name = desc.name;
meas.parameter = feval(fun.parameter,'create',h);
meas.value = feval(fun.value,'create');

%--------------------------------------------------------
% COMPUTE ACCORDING TO MODE
%--------------------------------------------------------

switch (mode)
	
	%--------------------------------------------------------
	% OUTPUT MEASUREMENT
	%--------------------------------------------------------
	
	case ('create')
	
		out = meas;
			
	%--------------------------------------------------------
	% OUTPUT MEASUREMENT DESCRIPTION
	%--------------------------------------------------------
	
	case ('describe')
	
		out = desc;
	
	%--------------------------------------------------------
	% BATCH ANNOTATE LOG EVENTS OR EVENT SEQUENCE (COMMAND LINE)
	%--------------------------------------------------------
	
	case ('batch')

		%--
		% rename input and handle sound or log 
		%--
		
		tmp = varargin{1};
		
		if (strcmp(tmp.type,'log'))
			
			%--
			% compute measurement of events from log
			%--
			
			%--------------------------------------------------------
			% (log,ix,meas)
			%--------------------------------------------------------
			
			log = tmp;
			ix = varargin{2};
			
			sound = log.sound;
			event = log.event(ix);
			
			flag_log = 1;
			
		else
			
			%--
			% compute measurement of sequence of orpaned events
			%--
			
			%--------------------------------------------------------
			% (sound,event,meas)
			%--------------------------------------------------------
			
			sound = tmp;
			event = varargin{2};
			
			flag_log = 0;
			
		end
		
		%--
		% compare input measurement name to measurement to compute
		%--
		
		meas = varargin{3};
		
		if (~strcmp(meas.name,desc.name))

			%--
			% return on improper measurement (parameter) input
			%--
			
			disp(' '); 
			warning(['Input measurement is ''' meas.name ''' not ''' desc.name '''.']);
			
			out = [];
			
			return;
			
		end
		
		%--
		% get current date
		%--
		
		curr = now;
		
		%--
		% add or update measurement in event sequence
		%--
		
		for k = 1:length(event)
			
			%--
			% get index of measurement
			%--
			
			tmp = struct_field(event(k).measurement,'name');
			ixa = find(strcmp(tmp,desc.name));
			
			%--
			% compute measurement
			%--
			
			if (isempty(ixa))
				
				%--
				% get position for new measurement in event measurement array
				%--
				
				len = length(event(k).measurement);
				if ((len == 1) & isempty(event(k).measurement(1).name))
					len = 0;
				end
				
				%--
				% set creation and modification date for measurement
				%--
				
				meas.created = curr;
				meas.modified = [];
				
				%--
				% try to compute measurement for event in sequence
				%--
				
				try
					
					%--
					% compute measurement and store in event measurement array
					%--
					
					% older measurement interface
					
% 					meas.value =  ...
% 						measurement_compute(sound,event(k),meas.parameter);
					
					meas.value = ...
						feval(fun.compute,sound,event(k),meas.parameter);
					
					event(k).measurement(len + 1) = meas;
	
				catch

					% there are many ways for a computation to fail there
					% is room here for the event to provide an indication
					% of why it failed to compute
					
					disp(' ');
					warning(['Failed to compute ''' desc.name ''' for event ' num2str(event.id)]);
					
				end
				
			%--
			% recompute measurement
			%--
			
			else
				
				%--
				% set measurment modification date
				%--
				
				meas.created = event(k).measurement(ixa).created;
				meas.modified = curr;
				
				%--
				% try to compute measurement for event in sequence
				%--
				
				try
					
					%--
					% compute measurement and store in event measurement array
					%--
					
					meas.value = ...
						feval(fun.compute,sound,event(k),meas.parameter);
					
					event(k).measurement(ixa) = meas;
				
				catch
					
					% there are many ways for a computation to fail there
					% is room here for the event to provide an indication
					% of why it failed to compute
					
					disp(' ');
					warning(['Failed to compute ''' desc.name ''' for event ' num2str(event.id)]);
					
				end
				
			end
			
		end
		
		%--
		% output updated log or events sequence
		%--
		
		if (flag_log)
			
			%--
			% output log with measurements added
			%--
			
			%--------------------------------------------------------
			% (log,ix,meas)
			%--------------------------------------------------------
			
			log.event(ix) = event;
			out = log;
			
		else
			
			%--
			% output sequence of orpaned events with measurements added
			%--
			
			%--------------------------------------------------------
			% (sound,event,meas)
			%--------------------------------------------------------
			
			out = event;
			
		end
		
	%--------------------------------------------------------
	% COMPUTE MEASUREMENT OF BROWSER DISPLAYED EVENTS
	%--------------------------------------------------------
	
	case ('events')
			
		%--
		% rename input variables
		%--
			
		h = varargin{1};
		m = varargin{2};
		ix = varargin{3};
		
		%--
		% get figure userdata
		%--
		
		data  = get(h,'userdata');
		
		%--
		% handle log browser get parent userdata
		%--
	
		if (gcf == h)
			flag = 0;
		else
			flag = 1;
		end
		
		%--
		% set default parameter for parameter edit
		%--
		
		nix = length(ix);
		
		if (nix == 1)
			
			%--
			% get measurement index for event
			%--
			
			event = data.browser.log(m).event(ix);
			ixa = find(strcmp(struct_field(event.measurement,'name'),desc.name));
			
			%--
			% get default parameter or current measurement parameter
			%--
			
			if (isempty(ixa))
				param = meas.parameter;	
			else
				param = event.measurement(ixa).parameter;	
			end 
			
		else
			
			%--
			% get current default parameter
			%--
			
			param = meas.parameter;
			
		end
		
		%--
		% allow for batch computation within browser
		%--
		
		% this modality of the call to the measurement interface is used to
		% update the value of a measurement upon event editing
		
		flag_batch = (length(varargin) > 3);
		
		if (flag_batch)
			
			%--
			% use input parameter
			%--
			
			param = varargin{4}.('parameter');	
			author = data.browser.author;
			
		else
		
			%--
			% edit parameter
			%--
					
			file = file_ext(data.browser.log(m).file);
			
			% this title should be changed to something more descriptive
			
			title_str = file;
	% 		title_str = 'Selected Set';
			
			[param,author] = measure_parameter_edit( ...
				desc, ...
				title_str, ...
				param, ...
				data.browser.author ...
			);
		
		end
		
		%--
		% update persistent parameters and browser author
		%--
		
		if (~isempty(param))
			
			data.browser.author = author;
			
		else
			
			%--
			% return on cancel of parameter edit dialog
			%--
			
			out = 0;
			return;
			
		end
		
		%--
		% create waitbar and get start time
		%--
		
		% the waitbar is created if more than 20 events are processed this
		% may be better set as a measurement parameter
		
		if (nix > 20)
			
			hw = wait_bar(0,'');
			set(hw,'name',[desc.name '  -  ' file]);
			
			start_time = clock;
			
			flag_wait = 1;
			
		else
			
			flag_wait = 0;
			
		end
		
		%--
		% set common values of measurements including parameters
		%--
		
		meas.author = author;
		
		curr = now;
		meas.created = curr;
		meas.modified = [];
		
		meas.parameter = param;
		
		%--
		% compute measurement for all indicated events
		%--
		
		for k = 1:nix
	
			%--
			% copy event from log and get measurement index
			%--
			
			event = data.browser.log(m).event(ix(k));
			
			ixa = find(strcmp(struct_field(event.measurement,'name'),desc.name));
			
			%--
			% compute measurement
			%--
			
			if (isempty(ixa))
				
				%--
				% set location in event measurement array
				%--
				
				len = length(event.measurement);
				if ((len == 1) & isempty(event.measurement(1).name))
					len = 0;
				end
				
				%--
				% try to compute measurement
				%--
				
				try
					
					%--
					% compute measurement and store in event measurement array
					%--
					
					% older measurement interface
					
% 					meas.value =  ...
% 						measurement_compute(data.browser.sound,event,meas.parameter);
					
					meas.value =  ...
						feval(fun.compute,data.browser.sound,event,meas.parameter);
					
					event.measurement(len + 1) = meas;
					
				catch
				
					% there are many ways for a computation to fail there
					% is room here for the event to provide an indication
					% of why it failed to compute
					
					disp(' ');
					warning(['Failed to compute ''' desc.name ''' for event ' num2str(event.id)]);
					
				end
						
			%--
			% recompute measurement
			%--
			
			else
			
				%--
				% set measurement modification date
				%--
				
				meas.created = event.measurement(ixa).created;
				meas.modified = curr;
				
				%--
				% try to compute measurement
				%--
				
				try
					
					% older measurement interface
					
% 					meas.value =  ...
% 						measurement_compute(data.browser.sound,event,meas.parameter);
					
					meas.value =  ...
						feval(fun.compute,data.browser.sound,event,meas.parameter);
					
					event.measurement(ixa) = meas;
					
				catch
				
					% there are many ways for a computation to fail there
					% is room here for the event to provide an indication
					% of why it failed to compute
					
					disp(' ');
					warning(['Failed to compute ''' desc.name ''' for event ' num2str(event.id)]);
					
				end
							
			end
			
			%--
			% put measured event back into log
			%--
			
			data.browser.log(m).event(ix(k)) = event;
			
			%--
			% update waitbar
			%--
			
			% the waitbar is updated every 10 events this may be better
			% done as measurement parameter
			
			if (flag_wait & ~mod(k,10))
				waitbar((k / nix),hw, ...
					['Events Processed: ' int2str(k) ', Elapsed Time: ' num2str(etime(clock,start_time),'%5.2f')]);
			end
				
		end
		
		%--
		% indicate that we are updating and saving log
		%--
		
		if (flag_wait)
			waitbar(1,hw, ...
				['Updating and saving log ''' file ''' ...'] ...
			);
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
		% save log if needed
		%--
		
		if (data.browser.log(m).autosave)
			log_save(data.browser.log(m));
		end
		
		%--
		% close waitbar
		%--
		
		if (flag_wait)
			close(hw);
		end
		
		%--
		% update event display
		%--
	
		if (flag == 1)
			
			%--
			% log browser display update for a single or for multiple events
			%--
			
			if (nix == 1)
				
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
				
				% this is not implemented yet
				
	% 			log_browser_display('events');
				
			end
			
		else
			
			%--
			% sound browser display update for a single or for multiple events
			%--
			
			if (nix == 1)
				
				%--
				% delete previous single event display objects
				%--
				
				delete(findall(h,'tag',[int2str(m) '.' int2str(ix)]));
				
				%--
				% rebuild single event display and selection
				%--
				
				event_view('sound',h,m,ix);
				event_bdfun(h,m,ix);
				
				drawnow;
				
			else
				
				%--
				% display all events in page
				%--
				
				browser_display(h,'events');
				
			end
			
		end
								
	%--------------------------------------------------------
	% DISPLAY MEASUREMENT INFORMATION IN MENU OR GRAPHICALLY
	%--------------------------------------------------------
	
	case ({'menu','display'})
		
		%--
		% rename input
		%--
	
		h = varargin{1};
		m = varargin{2};
		ix = varargin{3};
		
		%--
		% get userdata from figure if needed
		%--
		
		% this needs to be improved in view of the log browser 
		
		if (length(varargin) < 4)
			data = get(h,'userdata');
		else
			data = varargin{4};
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
	
		event = data.browser.log(m).event(ix);
		file = file_ext(data.browser.log(m).file);
		
		%--
		% check for existence of measurement
		%--
		
		ixa = find(strcmp(struct_field(event.measurement,'name'),desc.name));
		
		if (isempty(ixa))
			out = [];
			return;
		end
		
		%--
		% compute depending on display mode
		%--
		
		switch (mode)
			
			%--------------------------------------------------------
			% DISPLAY MEASUREMENT INFORMATION MENU
			%--------------------------------------------------------
			
			case ('menu')
				
				%--------------------------------------------------------
				% get event display parent handle
				%--------------------------------------------------------
				
				%--
				% sound browser display
				%--
				
				if (~flag_log)
				
					g = findobj(h,'type','patch','tag',[int2str(m) '.' int2str(ix)]);
					
				%--
				% log browser display
				%--
				
				else
					
					g = findobj(g,'type','axes','tag',[int2str(m) '.' int2str(ix)]);
					g = findobj(g,'type','image');
					
				end
				
				%--------------------------------------------------------
				% create menu display
				%--------------------------------------------------------
				
				if (isempty(g))
					
					%--
					% return because no parent was found
					%--
					
					out = [];
					return;
					
				else
		
					%--------------------------------------------------------
					% get contextual menu of parent then measurements menu
					%--------------------------------------------------------
					
					g = get(g,'uicontextmenu');
					
% 					g = get_menu(g,'Measurement');
					
					g = get_menu(g,'Measure');
		
					%--------------------------------------------------------
					% create measurement scheme menu display
					%--------------------------------------------------------
					
					L = { ...
						desc.name, ...
						'Display', ...
						'Recompute ...' ...
					};
				
					mg = menu_group(g,'',L);
					
					%--------------------------------------------------------
					% measurement information display menu
					%--------------------------------------------------------
					
					%--
					% check for custom menu function or use default
					%--
					
					if (isempty(fun.menu))
						
						% default menu provided by interface
						
						out = measure_menu(fun,mg(1),m,event,ixa,desc,data); 
						
					else
						
						% custom menu provided by user
						
						out = feval(fun.menu,mg(1),m,event,ixa,desc,data); 
						
					end
					
					%--------------------------------------------------------
					% add display options menu and callbacks
					%--------------------------------------------------------
					
					%--
					% append display modes to display
					%--
					
					L = feval(fun.display);
					
					n = length(L);
					
					S = bin2str(zeros(1,n));
					if (strcmp(L{1},'Inline'))
						S{2} = 'on';
					end
					
					tmp = menu_group(mg(2),'',L,S);
						
					out = [out, tmp];
					
					%--
					% add display submenu callbacks
					%--
					
					
					
					%--------------------------------------------------------
					% add recompute callback
					%--------------------------------------------------------
						
					%--
					% get measurement main function string equivalent
					%--
					
					str = func2str(fun.main);
					
					%--
					% the callback recreates the handles by calling main
					%--
					
					% this callback has to be updated. it is not clear
					% how this generalizes
					
					str = [ ...
						'measure_api(' str ',''events'',' ...
						int2str(h) ',' int2str(m) ',' int2str(ix) ');' ...
					];
				
					%--
					% set callback
					%--
					
					set(mg(2),'callback',str);
					
					%--------------------------------------------------------
					% add separators for different measurements
					%--------------------------------------------------------
					
					if (get(mg(1),'position') > 1)
						set(mg(1),'separator','on');
					end
					
					%--
					% add parent menu handles to output
					%--
					
					out = [mg, out];
					
				end
					
			%--------------------------------------------------------
			% DISPLAY MEASUREMENT GRAPHICALLY
			%--------------------------------------------------------
			
			case ('display')
				
				%--
				% check for user provided inline display and display
				%--
				
				if (~isempty(fun.display))
					
					%--
					% call user provided display function and get created object handles
					%--
					
					out = feval(fun.display,h,m,event,ixa,desc,data);
											
					%--
					% tag objects with log and event indices string
					%--
					
					set(out,'tag',[int2str(m) '.' int2str(ix)]);
					
				else
					
					%--
					% there is no default display for measurements
					%--
					
					out = [];
					
				end
			
		end
		
end


%--------------------------------------------------------
% DEFAULT XBAT MEASUREMENT FUNCTIONS
%--------------------------------------------------------

%--------------------------------------------------------
% PARAMETER_EDIT (DEFAULT)
%--------------------------------------------------------

function [param,author] = measure_parameter_edit(fun,desc,title,param,author)

% measure_parameter_edit - description generated edit dialog for parameter
% -----------------------------------------------------------------
%
% [param,author] = measure_parameter_edit(fun,desc,title,param,author)
%
% Input:
% ------
%  fun - measurement function handles 
%  desc - measurement description
%  title - title for edit dialog
%  param - input parameter
%  author - current author
%
% Output:
% -------
%  param - parameter structure
%  author - author of parameter selection

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 132 $
% $Date: 2004-12-02 15:58:47 -0500 (Thu, 02 Dec 2004) $
%--------------------------------

%--
% get measurement name and parameter description
%--

name = desc.name;

parameter = desc.parameter;

%--
% unpack parameter into cell array
%--

ans = feval(fun.parameter,'unpack',param);

%--
% get indices of editable fields
%--

n = length(parameter.input);

for k = 1:n
    ix(k) = find(strcmp(parameter.field,parameter.input(k)));
end

% ensure that author field is editable

ix = [ix, n + 1];

%--
% update dialog default value using input parameter
%--

for k = 1:n
	
	%--
	% update according to input type
	%--
	
	switch (class(parameter.default{ix(k)}))	
			
		%--
		% editable text box
		%--
		
		case ('char')
			
			parameter.default{ix(k)} = ans{ix(k)};
			
		%--
		% slider input
		%--
		
		case ('double')
			
			parameter.default{ix(k)}(1) = ans{ix(k)};
			
		%--
		% popup or listbox input
		%--
		
		case ('cell')
			
			ixl = find(strcmp(parameter.default{ix(k)},ans{ix(k)}));
			
			if (~isempty(ix))
				parameter.default{ix(k)}{end} = ixl;
			else
				parameter.default{ix(k)}{end} = 1;
			end
				
	end

end

%--
% add author field to input dialog
%--

parameter.field{n + 1} = 'Author';
parameter.default{n + 1} = author;
parameter.line(n + 1,:) = [1,26];
parameter.tip{n + 1} = 'Author of parameter settings';

%--
% build parameter editing input dialog
%--

tmp = input_dialog( ...
	parameter.field(ix), ...
	[name '  -  ' title], ...
	parameter.line(ix,:), ...
	parameter.default(ix), ...
	parameter.tip(ix) ...
);

%--
% output edited parameter if needed
%--

if (isempty(tmp))
	
	param = [];
	author = '';
	
else
	
	author = author_validate(tmp{n + 1});
    
	if (isempty(author))
		param = [];
	else
        
        for k = 1:n
            ans{ix(k)} = tmp{k};
        end
                
		param = feval(fun.parameter,'pack',ans);
		
	end
	
end

	
%--------------------------------------------------------
%  MEASUREMENT_MENU (DEFAULT)
%--------------------------------------------------------

function g = measure_menu(fun,h,m,event,ixa,desc,data)

% measure_menu - create description generated menu display
% ------------------------------------------------------------
%
% g = measure_menu(fun,h,m,event,ixa,desc,data)
%
% Input:
% ------
%  fun - measurement function handles
%  h - handle to parent
%  m - log index
%  event - measured event
%  ixa - measurement index in event
%  desc - measurement description
%  data - figure userdata context
%
% Output:
% -------
%  g - handles to created menus

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 132 $
% $Date: 2004-12-02 15:58:47 -0500 (Thu, 02 Dec 2004) $
%--------------------------------

%--
% unpack measurement structures to cell arrays
%--

param = feval(fun.parameter,'unpack',event.measurement(ixa).parameter);

value = feval(fun.value,'unpack',event.measurement(ixa).value);

%--
% create value menu
%--

name = desc.name;

desc = desc.value;

n = length(desc.menu);
L = cell(1,n);
j = 1;

for k = 1:n
	
	%--
	% get field index
	%--
	
	ixf = find(strcmp(desc.field,desc.menu{k}));
	
	%--
	% create menu label depending on value type
	%--
	
	if (isempty(value{ixf}))
		
		L{k} = [title_caps(desc.field{ixf},'_'), ':  (Empty)'];
		
	else
		
		L{k} = [title_caps(desc.field{ixf},'_'), ':  '];
		
		%--
		% display according to value class and type
		%--
		
		switch (class(value{ixf}))	
			
			%--
			% string value
			%--
			
			case ('char')
								
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
				
				type = desc.type{ixf};
				
				%--
				% create menu according to value type
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
							if (data.browser.grid.time.realtime & ~isempty(data.browser.sound.realtime))
								
								date = datevec(data.browser.sound.realtime);
								time = date(4:6)*[3600,60,1]';
								L{k} = [L{k} sec_to_clock(time + value{ixf})];
								
							else
								L{k} = [L{k} sec_to_clock(value{ixf})];
							end
						end
						
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
						
						L{k} = [L{k} num2str(value{ixf}) ' ' type];
						
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

for k = 1:length(desc.separator)
	S{desc.separator(k)} = 'on';
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
	if (~isempty(findstr(L{k},'(Empty)')))
		set(g1(k),'enable','off');
	end
end

%--
% add author, creation and modification date information fields
%--

L = { ...
	['Author:  ' event.measurement(ixa).author], ...
	['Created:  ' datestr(event.measurement(ixa).created)] ...
};

if (~isempty(event.measurement(ixa).modified))
	L{3} = ['Modified:  ' datestr(event.measurement(ixa).modified)];
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
		tmp = value{ixc(k)};
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
