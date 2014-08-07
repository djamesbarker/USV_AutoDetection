function xml_disp(in, fun)

% xml_disp - display variable as xml
% ----------------------------------
%
% xml_disp(in, fun)
%
% Input:
% ------
%  in - variable

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
% $Revision: 1880 $
% $Date: 2005-09-29 17:29:36 -0400 (Thu, 29 Sep 2005) $
%--------------------------------

% TODO: develop XSLT and web display

% TODO: allow passing of arguments to callback, use cell array convention

%----------------------------------------
% HANDLE INPUT
%----------------------------------------

%--
% set default display handler
%--

if ((nargin < 2) || isempty(fun))
	fun = @screen_dump;
end

%----------------------------------------
% SERIALIZE AND DISPLAY INPUT
%----------------------------------------

%--
% serialize variable
%--

% NOTE: we use 'inputname' to pass the variable name

str = to_xml(in, [], inputname(1));

%--
% display
%--

fun(str);


%-----------------------------------------------
% SCREEN_DUMP
%-----------------------------------------------

function screen_dump(str)

%--
% replace element and matrix tags with concise tags
%--

pat = {'cell', 'element', 'matrix', 'struct'}; rep = {'C', 'E', 'M', 'S'};

for k = 1:length(pat)
	str = strrep(str, pat{k}, rep{k});
end

%--
% replace root directories
%--

str = strrep(str, strrep(xbat_root, '\', '\\'), '$XBAT_ROOT');

str = strrep(str, strrep(matlabroot, '\', '\\'), '$MATLAB_ROOT');

%--
% display to screen
%--

disp(sprintf(str));



