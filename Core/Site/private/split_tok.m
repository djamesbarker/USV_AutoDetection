function tok = split_tok(line)

%--
% hide quoted spaces from split parser
%--

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

ix = strfind(line, '"');

% NOTE: there are an even number of quotes

quoted = ~isempty(ix) && ~mod(length(ix), 2);

if quoted
	
	rep = char(12);
	
	for k = 1:2:length(ix)
		line(ix(k) + 1:ix(k + 1) - 1) = strrep(line(ix(k) + 1:ix(k + 1) - 1), ' ', rep);
	end

end

%--
% split on spaces
%--

tok = str_split(line, ' ');

%--
% reset hidden spaces if needed
%--

if quoted
	
	tok = strrep(tok, rep, ' ');

end
