function fonts = simple_fonts

% simple_fonts - list of simple fonts
% -----------------------------------
%
% fonts = simple_fonts
%
% Output:
% -------
%  fonts - list of simple, common fonts

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
% create persistent list and output
%--

% NOTE: 'Times' does not seem different from 'Times New Roman'

% NOTE: 'Courier' does not seem different from 'Courier New'

persistent SIMPLE_FONTS;

if isempty(SIMPLE_FONTS)
	
	SIMPLE_FONTS = { ...
		'Arial', ...
		'Bitstream Vera Sans', ...
		'Bitstream Vera Serif', ...
		'Book Antiqua', ...
		'Century Gothic', ...
		'Comic Sans MS', ...
		'Courier', ...
		'Courier New', ...
		'Futura', ...
		'Georgia', ...
		'Helvetica', ...
		'Lucida Console', ...
		'Lucida Grande', ...
		'Lucida Sans Unicode', ... 
		'Palatino Linotype', ...
		'Times', ...
		'Times New Roman', ...
		'Trebuchet MS', ...
		'Verdana' ...
	}';

end

fonts = SIMPLE_FONTS;
