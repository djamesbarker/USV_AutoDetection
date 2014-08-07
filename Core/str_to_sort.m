function out = str_to_sort(in)

% str_to_sort - convert sorting string to sorting structure
% ---------------------------------------------------------
%
% out = parse_sort(in)
%
% Input:
% ------
%  in - sorting string
%
% Output:
% -------
%  out - sorting structure

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
% check clause structure and get clauses
%--

ixp1 = findstr(in,'(');
ixp2 = findstr(in,')');

if (length(ixp1) ~= length(ixp2))
	disp(' '); 
	error('Parenthesis mismatch in input string.'); 
end

ixp = [ixp1; ixp2];
ixp = ixp(:)';

if any(ixp ~= sort(ixp))
	disp(' '); 
	error('Parenthesis mismatch in input string.'); 
end

for k = 1:length(ixp1)
	cl{k} = in (ixp1(k) + 1:ixp2(k) - 1);
end

%--
% parse each clause
%--

for k = 1:length(cl)
	
	ixc = findstr(cl{k},':');

	switch (length(ixc))
		
		case (1)
			out(k).parent = 'event';
			out(k).field = cl{k}(1:ixc(1) - 1);
			out(k).order = cl{k}(ixc(1) + 1:end);
			
		case (2)
			out(k).parent = cl{k}(1:ixc(1) - 1);
			out(k).field = cl{k}(ixc(1) + 1:ixc(2) - 1);
			out(k).order = cl{k}(ixc(2) + 1:end);
			
		otherwise
			disp(' '); 
			error('Improper clause in input string.'); 
			
	end
	
end
