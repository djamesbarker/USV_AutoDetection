function [status, result, str] = create_shortcut(target, par, link)

% create_shortcut - create a windows shortcut
% -------------------------------------------
%
% [status, result, str] = create_shortcut(target, par, link)
%
% Input:
% ------
%  target - target of shortcut
%  par - location of shortcut (def: windows desktop)
%  link - name of shortcut (def: same as target)
%
% Output:
% -------
%  status - system call status output
%  results - system call results output
%  str - command string

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
% $Revision: 1180 $
% $Date: 2005-07-15 17:22:21 -0400 (Fri, 15 Jul 2005) $
%--------------------------------

%------------------------------------------------------------
% HANDLE INPUT
%------------------------------------------------------------

%--
% set default name same as target
%--

if (nargin < 3) || isempty(link)
	[ignore, link] = path_parts(target);	
end

%--
% set default directory
%--

if (nargin < 2) || isempty(par)
	par = '~$folder.desktop$';
end

%------------------------------------------------------------
% BUILD AND EXECUTE COMMAND
%------------------------------------------------------------

if isunix
    system(['ln -s ', target, ' ', par]); return;
end

%--
% get tool file
%--

tool = nircmd;

%--
% create command string
%--

% NOTE: there are a series of functions with this pattern

str = ['"', tool.file , '" shortcut "', target, '" "', par, '" "', link, '"'];

[status, result] = system(str);

% NOTE: this is a little filesystem assertion to save us from possible threading problems

while ~exist(fullfile(par, [link, '.lnk']), 'file')
	
	disp('Waiting on create shortcut.'); 
	
	pause(0.1);
	
end
