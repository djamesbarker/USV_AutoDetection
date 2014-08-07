function [fail, varargout] = iterate(varargin)

% iterate - apply current function to array
% -----------------------------------------
%
% [fail, varargout] = iterate(varargin)
%
% Input:
% ------
%  varargin - caller input
%
% Output:
% -------
%  fail - number of items that failed
%  varargout - caller output

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

%------------------
% HANDLE INPUT
%------------------

% NOTE: we have not failed yet

fail = 0;

%--
% return for nothing
%--

if ~numel(varargin)
	return;
end

%--
% get items and args from input
%--

% NOTE: the first arguments is the array to iterate

items = varargin{1}; args = varargin(2:end); 

if ~numel(items)
	return;
end

%------------------
% SETUP
%------------------

%--
% get caller handle 
%--

fun = get_caller; fun = str2func(fun.name);

if isempty(fun) 
	error('Unable to access caller, it may be ''private''.');
end

%--
% inspect caller outputs
%--

request = nargout; total = nargout(fun);

if request > total
	error('Requested outputs exceed total outputs.');
end

% NOTE: we only handle no output iteration for the moment

if request
	return;
end

%------------------
% ITERATE
%------------------

for k = 1:numel(items)

	%--
	% get item
	%--
	
	if iscell(items)
		item = items{k};
	else
		item = items(k);
	end
	
	%--
	% process item
	%--
	
	try
		fun(item, args{:});
	catch
		xml_disp(lasterror); fail = fail + 1;
	end
	
	%--
	% pack outputs
	%--
	
end
