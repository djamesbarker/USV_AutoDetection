function out = tag_str(in, varargin)

% tag_str - tag string using xml tag
% ----------------------------------
%
% out = tag_str(in, tag)
%
%     = tag_str(in, name, class, id)
%
% Input:
% ------
%  in - string to tag
%  tag - tag struct
%  name - tag name
%  class - tag class
%  id - tag id
%
% Output:
% -------
%  out - tagged string

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
% $Revision: 2014 $
% $Date: 2005-10-25 17:43:52 -0400 (Tue, 25 Oct 2005) $
%--------------------------------

%--
% handle variable number of arguments
%--

% NOTE: this function uses simple recursion and calls to tag maker

arg = varargin;

switch length(arg)
	
	%--
	% tag or tag name input
	%--
	
	case 1
		
		switch class(arg{1})
			
			%--
			% tag name input
			%--
			
			case 'char', out = tag_str(in, xml_tag(arg{1}));
				
			%--
			% tag input
			%--
			
			case 'struct'
			
				tag = arg{1};
				
				if ~is_tag(tag)
					error('Struct input is not tag input.');
				end

				out = [tag.open, in, tag.close];
			
			%--
			% error
			%--
			
			otherwise, error('Improper tag description input.');
							
		end
	
	%--
	% name and class input
	%--
	
	case 2, out = tag_str(in, xml_tag(arg{1}, arg{2}));
		
	%--
	% name, class, and id input
	%--
	
	case 3, out = tag_str(in, xml_tag(arg{1}, arg{2}, arg{3}));
		
	%--
	% error
	%--
	
	otherwise, error('Improper number of tag description arguments.');
		
end


