function dirs = get_mex_dirs

% get_mex_dirs - get MEX directories within XBAT root
% ---------------------------------------------------
%
% dirs = get_mex_dirs
%
% Output:
% -------
%  dirs - MEX dirs within XBAT root

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

%----------------
% GET MEX DIRS
%----------------

%--
% scan directories with mex selection callback
%--

dirs = scan_dir(xbat_root, @get_mex);

if ~nargout
	xml_disp(dirs);
end


%----------------
% GET_MEX
%----------------

function file = get_mex(file)

if strmatch('XEM', fliplr(file))
	
else 
	file = [];
end
