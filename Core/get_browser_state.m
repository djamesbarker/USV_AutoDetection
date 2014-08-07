function state = get_browser_state(par, data, opt)

% get_browser_state - get browser display state
% ---------------------------------------------
%
% state = get_browser_state(par, data, opt)
%
%   opt = get_browser_state
%
% Input:
% ------
%  par - browser figure handle
%  data - browser userdata
%  opt - get state options
%
% Output: 
% -------
%  state - browser display state
%  opt - get state options

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
% $Revision: 6276 $
% $Date: 2006-08-22 02:01:51 -0400 (Tue, 22 Aug 2006) $
%--------------------------------

% TODO: browser state is split between this state and the sound 'state'

% NOTE: sounds and logs try to behave as annotated books in a library

%----------------------------------------------------
% HANDLE INPUT
%----------------------------------------------------

%--
% set get options
%--

if (nargin < 3) || isempty(opt)
	
	%--
	% create options structure
	%--
	
	% NOTE: only the 'extension_palettes' field is currently used
	
	opt.position = 1;
	
	opt.palettes = 1;
	
	opt.extension_palettes = 1;
	
	opt.log = 1;
	
	opt.selection = 1;
	
	%--
	% output get options
	%--
	
	if ~nargin
		state = opt; return;
	end
	
end
	
%--
% get userdata if needed
%--

if (nargin < 2) || isempty(data)
	data = get_browser(par);
end

%----------------------------------------------------
% GET SCREENSIZE AND BROWSER POSITION STATE
%----------------------------------------------------

% NOTE: the handling of the screensize in 'set' could use some work

state.screensize = get(0, 'screensize');

state.position = get(par, 'position');

%----------------------------------------------------
% GET PALETTE STATES
%----------------------------------------------------

%--
% get list of browser palette names if we are going to need it
%--

if ~opt.extension_palettes
	pals = browser_palettes;
end

% NOTE: we are not keeping state for extension palettes or extensions

%--
% get open palette states
%--

% NOTE: failure to capture state typically implies a missing palette field

if ~isempty(data.browser.palettes)
	
	state.palette = [];

	for k = 1:length(data.browser.palettes)
		
		%--
		% skip extension palettes if asked to
		%--
		
		if ~opt.extension_palettes
			
			if ~ismember(get(data.browser.palettes(k), 'name'), pals)
				continue;
			end
			
		end
		
		%--
		% try to capture palette state
		%--
		
        if ~ishandle(data.browser.palettes(k))
            continue;
        end
        
		try
			
			if isempty(state.palette)
				state.palette = get_palette_state(data.browser.palettes(k));
			else
				state.palette(end + 1) = get_palette_state(data.browser.palettes(k));
			end
			
        catch
            
			name = get(data.browser.palettes(k), 'name');
			
			nice_catch(lasterror, ['WARNING: Failed to capture ''', name, ''' palette state.']);
			
		end
		
	end
	
else
	
	state.palette = [];
	
end

%--
% get stored palette states
%--

% NOTE: these contain the states of palettes that are not currently open

state.palette_states = data.browser.palette_states;

%----------------------------------------------------
% GET OPEN LOGS STATE
%----------------------------------------------------

% TODO: handle 'struct_field' problem with scalar arrays

switch length(data.browser.log)
	
	%--
	% no logs open
	%--
	
	case 0, state.log = [];
		
	%--
	% a single log open
	%--
	
	case (1)
		
		state.log.names = {file_ext(data.browser.log.file)};
		
		state.log.ids = data.browser.log.id;
		
		state.log.active = data.browser.log_active;

	%--
	% multiple open logs
	%--
	
	otherwise
		
		state.log.names = file_ext(struct_field(data.browser.log, 'file'));
		
		state.log.ids = struct_field(data.browser.log, 'id');
		
		state.log.active = data.browser.log_active;
		
end

% NOTE: saving and loading of extension states should be available when presets are mature

%----------------------------------------------------
% GET FILTER STATE
%----------------------------------------------------

% NOTE: this will interact with the selection state and display

%----------------------------------------------------
% GET MEASURE AND ANNOTATION DISPLAY AND ACTIVE STATE
%----------------------------------------------------

% NOTE: these are perhaps too much in flux to consider at the moment

%----------------------------------------------------
% GET SELECTION STATE
%----------------------------------------------------

% TODO: the selection event is possibly linked to a log, problems?

state.selection = data.browser.selection;
