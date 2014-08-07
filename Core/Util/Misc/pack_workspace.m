function out = pack_workspace

% pack_workspace - pack workspace variables into structure
% --------------------------------------------------------
%
% out = pack_workspace
%
% Output:
% -------
%  out - workspace as structure

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

% TODO: use a variable name filter in the packing

% TODO: use a class filter for the packing

%--
% get variable names
%--

work = evalin('caller','whos');

%--
% return empty struct on empty workspace
%--

if (isempty(work))
	out = struct([]); return;
end

%--
% pack workspace variables into structure
%--

for k = 1:length(work)
	out.(work(k).name) = evalin('caller',work(k).name);
end
