function f = showf(fun, sel)

% showf - show function file in explorer
% --------------------------------------
%
% f = showf(fun, sel)
%
% Input:
% ------
%  fun - function name
%  sel - select file if possible on show (def: 1)
%
% Output:
% -------
%  f - file location

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
% $Revision: 4695 $
% $Date: 2006-04-20 11:22:26 -0400 (Thu, 20 Apr 2006) $
%--------------------------------

% TODO: update to show 'pwd' by default

%------------------------------
% HANDLE INPUT
%------------------------------

%--
% set file selection to on
%--

if (nargin < 2)
	sel = 1;
end

%------------------------------
% GET AND SHOW FILE
%------------------------------

%--
% get path using which
%--

f = which(fun);

%--
% display failure message
%--

if isempty(f)
	disp(['Unable to find function ''' fun ''' in MATLAB path.']); return;
end

%--
% handle built-in functions
%--

prefix = 'built-in (';

if strmatch(prefix, f)
	
	disp(' '); disp(['Function ''' fun ''' ia a built-in MATLAB function.']);

	% NOTE: this is the corresponding help and gateway file
	
	f = [f((length(prefix) + 1):(end - 1)), '.m'];
	
end

%--
% handle missing file
%--

if ~exist(f, 'file')
	disp(' '); disp(['File does not seem to exist.']); return;
end

%--
% open folder using explorer and select function file if needed
%--

if sel
	show_file(f);
else
	show_file(fileparts(f));
end

if ~nargout
	clear f;
end
