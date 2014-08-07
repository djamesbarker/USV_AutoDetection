function res = reg_exp(str, pat)

% reg_exp - match regular expression and pack result
% --------------------------------------------------
%
% res = reg_exp(str, pat);
%
% Input:
% ------
%  str - string to match
%  pat - regular expression
%
% Output:
% -------
%  res - results structure

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
% add string and pattern to result
%--

res.str = str; 

res.pat = pat;

%--
% match regular expression and add outputs to result
%--

[res.start, res.end, res.extent, res.match, res.token, res.name] = regexp(str, pat);

%--
% display result if no output
%--

% NOTE: we display the result and clear to avoid actual output display

if ~nargout
	disp(' '); disp(show_reg_exp(res)); disp(' '); clear res;
end
