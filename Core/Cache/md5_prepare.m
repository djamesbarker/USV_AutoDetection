function [val,str] = md5_prepare(in)

% md5_prepare - struct to char conversion for use with md5
% --------------------------------------------------------
%
% [val,str] = md5_prepare(in)
%
% Input:
% ------
%  in - input structure
%
% Output:
% -------
%  val - value string
%  str - field structure string

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

%--------------------------------------------------
% HANDLE INPUT
%--------------------------------------------------

%--
% check for struct input
%--

if (~isstruct(in))
	disp(' ');
	error('Struct input is required.');
end

%--
% check for scalar struct
%--

if (length(in) ~= 1)
	disp(' ');
	error('Scalar struct input is required.');
end

%--------------------------------------------------
% VALUE STRING
%--------------------------------------------------

%--
% flatten struct and get fieldnames
%--

in = flatten_struct(in);
		
names = fieldnames(in);

%--
% add values to fieldnames
%--

val = cell(size(names));

for k = 1:length(names)

	%--
	% handle values based on class and size
	%--

	% NOTE: the double, matrix, and string cases are the typical cases

	tmp = in.(names{k});

	switch (class(tmp))

		%--
		% numeric
		%--

		case ('double')

			if (length(tmp) == 1)
				val{k} = strcat(num2str(tmp,20),';');
			else
				val{k} = strcat(mat2str(tmp,20),';');
			end
			
		case ('logical')
			
			if (length(tmp) == 1)
				val{k} = strcat(int2str(tmp),';');
			else
				val{k} = strcat(mat2str(tmp,1),';');
			end
			
		%--
		% string
		%--

		case ('char')

			val{k} = strcat(tmp,';');
			
		%--
		% cell
		%--
		
		% NOTE: we only keep the number of elements in the cell
		
		case ('cell')
			
			val{k} = ['__CELL__' int2str(numel(tmp))];
			
		%--
		% otherwise
		%--
		
		otherwise
			
			val{k} = '__OTHER__';

	end

end

val = char(val);

%--------------------------------------------------
% FIELD STRUCTURE STRING
%--------------------------------------------------

if (nargout > 1)
	str = char(names);
end
