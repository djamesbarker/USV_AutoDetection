function value = can_explain(ext)

% can_explain - check whether an extension has any explain handlers
% -----------------------------------------------------------------
%
% value = can_explain(ext)
%
% Input:
% ------
%  ext - extension
%
% Output:
% -------
%  value - result of test

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

value = 0; 

%--
% check for explain branch in functions structure
%--

if ~isfield(ext.fun, 'explain')
	return;
end

%--
% check for any available explain handlers
%--

explain = flatten(ext.fun.explain);

fields = fieldnames(explain);

for k = 1:length(fields)
	if ~isempty(explain.(fields{k}))
		value = 1; return;
	end
end 
