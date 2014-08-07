 function [par, leaf] = path_parts(str)

% path_parts - separate directory path into parent and leaf
% ---------------------------------------------------------
%
% [par, leaf] = path_parts(str)
%
% Input:
% ------
%  str - directory path string
%
% Output:
% -------
%  par - parent part 
%  leaf - leaf part 

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
% $Revision: 1161 $
% $Date: 2005-07-05 16:25:08 -0400 (Tue, 05 Jul 2005) $
%--------------------------------

% TODO: use regular expressions to make sure results are correct

%-------------------------------------
% HANDLE INPUT
%-------------------------------------

%--
% remove final file separator if needed
%--

% NOTE: trim a final file separator, 'pwd' output does not have final filesep

if (str(end) == filesep)
	str(end) = [];
end

%-------------------------------------
% GET PARENT AND LEAF
%-------------------------------------

%--
% find file separators
%--

ix = findstr(str, filesep);

%--
% handle long path case
%--

if ~isempty(ix)
	
	%--
	% split into parent and leaf
	%--

	par = str(1:ix(end) - 1); leaf = str(ix(end) + 1:end);

	%--
	% consider special parent cases
	%--

	% NOTE: consider drive parent
	
	if strcmp(par(end), ':')
		par(end + 1) = filesep;
	end

	% TODO: consider network drive
	
else
	
	% NOTE: allow the string to indicate a parent with no leaf
	
	par = str; leaf = '';
	
end

