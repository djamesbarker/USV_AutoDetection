function log_unlock(log)

% log_unlock - restore write permissions on log file
% -----------------------------------------
%
% log = log_unlock(log)
%
% Input:
% ------
%  log - log structure
%
% Output:
% -------

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

% NOTE: This only sets the permissions on the file. It would be a better
% solution to lock the file, which would release when the process
% terminates. However, this does not appear to be possible without using a
% MEX file which is then brittle and nonportable.

% TODO: Support for Mac and Linux

if ispc
    cmd = ['cacls "' log.path filesep log.file '" /E /P everyone:F'];
    system(cmd);
end

