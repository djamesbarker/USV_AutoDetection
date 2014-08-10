%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 1380 $
% $Date: 2005-07-27 18:37:56 -0400 (Wed, 27 Jul 2005) $
%--------------------------------

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

annotation another "Another"

	%--
	% annotation metadata
	%--

	author "Harold K. Figueroa"

	version 0.1.10

	namespace 1

	%--
	% annotation definition
	%--

	group swim "Swim"

		flipper "Dolphin" = text 2;

		propeller "Machine" = text 8; 

	group fly "Fly" 

		subgroup birds "Birds" 
 
			% test "Text" = text;

			head "Crest" = {"Red","Green","Blue"}; 

			tail "Tail" = {"Short","Long"};

		subgroup bees "Bees" 

			% head "My head" = text;

			legs "Number of Legs" = text;

			wings "Wings" = text; 

			sting "Sting" = 1:10; 

	group test "Comments"
		
		comments "My Comments" = text 12;

end
