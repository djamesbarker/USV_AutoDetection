function opt = nice_catch(info, str, opt)

% nice_catch - typically used to produce warnings from catch blocks
% -----------------------------------------------------------------
%
% nice_catch(info, str, opt)
%
% opt = nice_catch
%
% Input:
% ------
%  info - error info struct as provided by 'lasterror'
%  str - message string
%  opt - options
%
% Output:
% -------
%  opt - options

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

% TODO: implement logging, save to file, then optionally report to site

%----------------
% HANDLE INPUT
%----------------

%--
% set and possibly output default options
%--

% NOTE: the log field indicates the log file to use, this should contain
% name and file extension, the file extension will determine storage type

if nargin < 3
	
	opt.log = ''; opt.timestamp = 0;
	
	if ~nargin && nargout
		return;
	end
	
end

%--
% set default message
%--

% NOTE: the message really wants to be called from a catch!

if nargin < 2
	str = 'WARNING: Exception handled.';
end

%--
% get lasterror if needed
%--

if ~nargin || isempty(info)
	info = lasterror;
end

%----------------
% DISPLAY
%----------------

%--
% pad message and create line
%--

str = [' ', str];

% NOTE: these numbers may not be precise, consider factoring this

n = 64; % max(64, length(str) + 1); 

line = str_line(n, '_');

%--
% display warning
%--

if ~isstruct(info)
	return;
end

disp(' '); 

disp(line);
disp(' '); 
disp(str);
disp(line);

disp(' '); 

nice_catch_error(info);

disp(' ');
disp(line);
disp(' ');

	
