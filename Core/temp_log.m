function log = temp_log(sound)

% detector_log - create temporary log
% -----------------------------------
%
% log = temp_log(sound)
%
% Input:
% ------
%  sound - log sound
%
% Output:
% -------
%  log - temporary log structure

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
% $Revision: 1174 $
% $Date: 2005-07-13 16:54:00 -0400 (Wed, 13 Jul 2005) $
%--------------------------------

% NOTE: the file is deleted after creation, log can be saved if needed

%--
% create log using temporary file name
%--

log = log_create([tempname '.mat']);

%--
% set log sound
%--

if (nargin)
	log.sound = sound; 
end

%--
% set display options for temporary log
%--

log.linestyle = ':';

log.linewidth = 0.5;

log.color = [1 0 0];

log.autosave = 0;

log.autobackup = 0;

%--
% delete log file
%--

delete([log.path, log.file]);
