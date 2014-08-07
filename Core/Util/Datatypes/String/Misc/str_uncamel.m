function out = str_uncamel(in, sep)

% str_uncamel - convert camel string to separated string
% ------------------------------------------------------
%
% out = str_uncamel(in, sep)
%
% Input:
% ------
%  in - camel string
%  sep - output separator (def: '_')
%
% Output:
% -------
%  out - separated string

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 1600 $
% $Date: 2005-08-18 17:41:06 -0400 (Thu, 18 Aug 2005) $
%--------------------------------

% TODO: implement this using 'regexprep', there are problems currently

%----------------------------------------
% HANDLE INPUT
%----------------------------------------

%--
% set default separator
%--

if nargin < 2
	sep = '_';
end

%--
% check for camelback string
%--

ix = find(in == upper(in));

% NOTE: return if string is all lower

if isempty(ix)
	out = in; return;
end

% NOTE: disregard leading capital letter in processing

if ix(1) == 1
	ix = ix(2:end);
end

% NOTE: return if there is nothing to do

if isempty(ix)
	out = in; return;
end

%----------------------------------------
% PROCESS STRING
%----------------------------------------

% NOTE: add separator to upper from lower transitions

out = in(1:(ix(1) - 1));

for k = 1:(length(ix) - 1)
	out = [out, sep, in(ix(k):(ix(k + 1) - 1))];
end

out = [out, sep, in(ix(end):end)];
