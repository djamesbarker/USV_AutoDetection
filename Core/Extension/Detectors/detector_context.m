function context = detector_context(ext,sound,scan,channels,log,par,data)

% detector_context - pack context
% -------------------------------
%
% context = detector_context(ext,sound,scan,channels,log)
%
% context = detector_context(ext,sound,scan,channels,log,par,data)
%
% Input:
% ------
%  ext - detector extension
%  sound - sound to scan
%  scan - scan
%  channels - channels to scan
%  log - output log
%  par - parent browser
%  data - parent state
%
% Output:
% -------
%  context - context

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

%--------------------------
% HANDLE INPUT
%--------------------------

%--
% check for parent browser
%--

if (nargin < 6)
	par = [];
end

%--
% handle other input considering parent availability
%--

if (~isempty(par))
	
	%--
	% check browser input and get state if needed
	%--

	if (~is_browser(par))
		error('Input handle is not browser handle.');
	end

	if ((nargin < 7) || isempty(data))
		data = get_browser(par);
	end

	%--
	% get active log if needed
	%--

	% NOTE: there is a single sound per parent, but possibly multiple logs

	% TODO: implement 'get_active_log' 
	
	if (nargin < 5)
		log = get_active_log(par,data);
	end

	%--
	% get sound from parent
	%--

	if ((nargin < 2) || isempty(sound))
		sound = data.browser.sound;
	end
	
else
	
	%--
	% get sound from log if needed
	%--
	
	if ((nargin < 2) || isempty(sound))
		
		if ((nargin < 5) || isempty(log))
			error('A context log is needed if no parent browser is available.');
		end

		sound = log.sound;

	end
	
	if (nargin < 5)
		log = [];
	end
	
end

%--
% get default scan
%--

if ((nargin < 2) || isempty(scan))
	scan = get_sound_scan(sound);
end

%--------------------------
% COMPILE CONTEXT
%--------------------------

%--
% get basic context elements
%--

context.ext = ext; 

context.sound = sound; 

context.scan = scan;

context.channels = channels;

context.log = log;

%--
% get parent context elements
%--

context.par = par;

% NOTE: get active extensions from parent browser

types = get_extension_types;

if (~isempty(par))
	for k = 1:length(types)
		context.active.(types{k}) = get_active_extension(types{k},par,data);
	end
else
	for k = 1:length(types)
		context.active.(types{k}) = [];
	end
end

%--
% add read and write context elements
%--

context.state = [];

% NOTE: the extension explain state should not be copied

if isfield(ext.control, 'explain')
    context.explain.on = ext.control.explain;
else
    context.explain.on = 0;
end
    
context.explain.fig = [];

context.explain.data = [];

context.explain.parameter = [];
