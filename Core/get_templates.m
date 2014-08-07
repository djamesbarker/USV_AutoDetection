function [TEMP,TEMP_NAME] = get_templates(mode)

% get_templates - get currently available templates
% -------------------------------------------------
%
% [TEMP,TEMP_NAME] = get_templates
%                  = get_templates('update')
%
% Output:
% -------
%  TEMP - template structure array
%  TEMP_NAME - template names cell array

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

%--
% set mode
%--

if (~nargin)
	mode = '';
end 

%--
% create persistent template structure array and names
%--

persistent PERSISTENT_TEMP PERSISTENT_TEMP_NAME;

%--
% get template information if needed or 'update' requested
%--

if (isempty(PERSISTENT_TEMP) | strcmp(mode,'update'))
	
	%--
	% get functions in 'templates' directory
	%--
	
	mat = what('Templates'); 
	mat = mat.mat;
	
	%--
	% get template information
	%--
	
	if (length(mat))
		j = 1;
		for k = 1:length(fun)
			if findstr(mat{k},'_template')
				tmp = load(mat{k});
				if (j == 1)
					PERSISTENT_TEMP = tmp;
				else
					PERSISTENT_TEMP(j) = tmp;
				end
				PERSISTENT_TEMP_NAME{j} = tmp.name;
				j = j + 1;
			end
		end
	end
	
	%--
	% sort templates by names
	%--
	
	[PERSISTENT_TEMP_NAME,ix] = sort(PERSISTENT_TEMP_NAME);
	PERSISTENT_TEMP = PERSISTENT_TEMP(ix);
	
end

%--
% output template structure array and template names
%--

TEMP = PERSISTENT_TEMP;
TEMP_NAME = PERSISTENT_TEMP_NAME;
