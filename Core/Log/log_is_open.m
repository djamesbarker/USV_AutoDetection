function [g, h] = log_is_open(log, h)

% log_is_open - try to see whether log is open
% --------------------------------------------
%
% g = log_is_open(log, h)
%
% Input:
% ------
%  log - log structure
%  h - figures to check
%
% Output:
% -------
%  g - handle of figure with open log
%  h - figures checked

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

%--
% set figures to check
%--

% at the moment we only check the sound browser windows

if (nargin < 2)
	h = get_xbat_figs('type', 'sound');
end

%--
% return if there are no candidate windows open
%--

if isempty(h)
	g = []; return;
end

%--
% loop over figures checking for log
%--
	
g = [];

for k = 1:length(h)
	
	%--
	% get userdata
	%--
	
	data = get(h(k),'userdata');
	
	%--
	% there are some logs in this figure
	%--
	
	if ~isempty(data.browser.log)
		
		%--
		% compare log file names
		%--
				
		ix = find(strcmp(struct_field(data.browser.log, 'file'), log.file));
		
		%--
		% compare log paths
		%--
				
		if ~isempty(ix)
			
			if strcmp(data.browser.log(ix).path, log.path)
				
				% TODO: we only want to have a log open at the moment, however we
				% may allow various logs open if we implement the read-only
				% option
				
				g = h(k); return;
				
			end
		end
		
	end
	
end
	
