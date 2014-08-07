function [moved, file] = fmove(name, target)

% fmove - move a file to be with another file
% -------------------------------------------
%
% fmove name target
%
% [moved, file] = fmove(name, target)
%
% Input:
% ------
%  name - function or file to move
%  target - function or file at target location
%
% Output:
% -------
%  moved - indicator
%  file - result

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

moved = 0;

%--
% get full source location and desired parent
%--

% NOTE: this is the file that the name maps to, we compute here and at the end

file = which(name);

if isempty(file)
	return;
end

par = fcd(target);

if isempty(par)
	return;
end

%--
% try to move source file to target location
%--

[ignore, name, ext] = fileparts(file);

result = [par, filesep, name, ext];

moved = movefile(file, result);

file = which(name);

%--
% display file for no output
%--

if ~nargout
	clear moved; disp(file);
end

