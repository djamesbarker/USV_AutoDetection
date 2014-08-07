function range = str_to_range(str)

% str_to_range - parse string to range structure
% ----------------------------------------------
%
% range = str_to_range(str)
%
% Input:
% ------
%  str - string to parse
%
% Output:
% -------
%  range - range structure

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
% $Revision: 132 $
% $Date: 2004-12-02 15:58:47 -0500 (Thu, 02 Dec 2004) $
%--------------------------------

% TODO: use regular expression machinery more effectively

%---------------------------------------------
% HANDLE INPUT
%---------------------------------------------

%--
% simple handling of multiple strings
%--

if (iscell(str) && (length(str) > 1))
	
	for k = 1:length(str)
		range(k) = str_to_range(str{k});
	end
	
end

%---------------------------------------------
% PARSE RANGE STRING
%---------------------------------------------

% NOTE: we may check for explicit 'linspace' and 'logspace'

%--
% check for brackets
%--

switch (str(1));
	
	%--
	% interval range
	%--
	
	case ({'[','('})
		range = parse_interval(str);
		
	%--
	% set range
	%--
	
	case ('{')
		range = parse_set(str);
		
	%--
	% colon range
	%--
	
	otherwise
		range = parse_colon(str);
		
end

%---------------------------------------------
% PARSE_INTERVAL
%---------------------------------------------

function range = parse_interval(str)

% parse_interval - parse string into interval range
% -------------------------------------------------
%
% range = parse_interval(str)
%
% Input:
% ------
%  str - string to parse
%
% Output:
% -------
%  range - range structure

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 132 $
% $Date: 2004-12-02 15:58:47 -0500 (Thu, 02 Dec 2004) $
%--------------------------------

% TODO: replace 'str2num' with 'str_to_double' when it's done
	
%--
% split interval string
%--

[c,d] = strtok(str,',');

%--
% parse left endpoint type and value 
%--

l = (c(1) == '[');

c = c(2:end);

if (findstr(c,':'))
	c = clock_to_sec(c);
else
	c = str2num(c); 
end

%--
% parse right endpoint type and value
%--

u = (d(end) == ']');

d = d(2:end - 1);

if (findstr(d,':'))
	d = clock_to_sec(d);
else
	d = str2num(d); 
end
	
%--
% check order of endpoints
%--

if (c > d)
	disp(' ')
	error('Improperly ordered interval.');
end

%--
% get interval type from bracket tests
%--

type =  2*l + 1*u;

switch (type)
	
	case (0), type = 'open'; 	
	case (1), type = 'left_open';	
	case (2), type = 'right_open';
	case (3), type = 'closed'; 
		
end

%--
% output range
%--

range = range_create('interval', ...
	'ends',[c,d], ...
	'type',type ...
);


%---------------------------------------------
% PARSE_SET
%---------------------------------------------

function range = parse_set(str)

% parse_set - parse string into set range
% ---------------------------------------
%
% range = parse_set(str)
%
% Input:
% ------
%  str - string to parse
%
% Output:
% -------
%  range - range structure

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 132 $
% $Date: 2004-12-02 15:58:47 -0500 (Thu, 02 Dec 2004) $
%--------------------------------

%--
% remove set brackets
%--

str = str(2:end - 1)

%--
% get whitespace separated string tokens and try to evaluate them
%--

tok = regexp(str,'\w*','match');

for k = 1:length(tok)
		
	% NOTE: this allows for mixed lists of strings and evaluated strings
	
	try
		value = eval(tok{k});
	catch
		value = [];
	end
	
	if (~isempty(value))
		tok{k} = value;
	end
	
end

%--
% output range
%--

range = range_create('set', ...
	'element',tok ...
);


%---------------------------------------------
% PARSE_COLON
%---------------------------------------------

function range = parse_colon(str)

% parse_colon - parse string into colon range
% -------------------------------------------
%
% range = parse_colon(str)
%
% Input:
% ------
%  str - string to parse
%
% Output:
% -------
%  range - range structure

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 132 $
% $Date: 2004-12-02 15:58:47 -0500 (Thu, 02 Dec 2004) $
%--------------------------------

%--
% get colon breaks
%--

ix = findstr(str,':');

if (length(ix) > 2)
	disp(' ');
	error('Improper colon string');
end

%--
% evaluate start, increment and end parts of colon string
%--

c1 = eval(str(1:ix(1) - 1));
if (~isreal(c1))
	disp(' ');
	error('Improper colon start string');
end

c2 = eval(str(ix(1) + 1:ix(2) - 1));
if (~isreal(c2))
	disp(' ');
	error('Improper colon increment string');
end

c3 = eval(str(ix(2) + 1:end));
if (~isreal(c3))
	disp(' ');
	error('Improper colon end string');
end

%--
% output range
%--

range = range_create('colon', ...
	'start',c1, ...
	'inc',c2, ...
	'end',c3 ...
);
