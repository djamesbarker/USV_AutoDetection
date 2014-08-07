function par = fcd(name)

% fcd - get or move to function or file parent directory
% ------------------------------------------------------
%
% fcd name; par = fcd(name)
%
% Input:
% ------
%  name - function or file name
%
% Output:
% -------
%  par - parent directory

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
% return current directory if no input
%--

% NOTE: in this case there is no need to move

if nargin < 1
	par = pwd; return;
end

%--
% get function or file location using which 
%--

% NOTE: this step is fragile, since MATLAB could change the prefix

par = which(name);

prefix = 'built-in (';

if strmatch(prefix, par)
	par(end) = []; par(1:length(prefix)) = [];
end

%--
% get parent directory, move to it if needed
%--

par = fileparts(par);

if ~isempty(par) && ~nargout
	cd(par);
end
