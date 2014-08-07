function [ANNOT,ANNOT_NAME] = get_annotations(mode)

% get_annotations - get currently available annotations
% ------------------------------------------------------
%
% [ANNOT,ANNOT_NAME] = get_annotations
%                    = get_annotations('update')
%
% Output:
% -------
%  ANNOT - annotation structure array
%  ANNOT_NAME - annotation names cell array

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
% $Revision: 1421 $
% $Date: 2005-08-01 17:03:23 -0400 (Mon, 01 Aug 2005) $
%--------------------------------

%--
% set mode
%--

if (~nargin)
	mode = '';
end 

%--
% create persistent annotation structure array and names
%--

persistent PERSISTENT_ANNOT PERSISTENT_ANNOT_NAME;

%--
% get annotation information if needed or 'update requested'
%--

if (isempty(PERSISTENT_ANNOT) | strcmp(mode,'update'))
	
	%--
	% get functions in 'annotations' directory
	%--
	
	fun = what([extensions_root, filesep, 'Annotations']); 
	
	fun = what([fun.path, filesep, 'Event']);

	fun = unique(file_ext({fun.m{:}, fun.p{:}}));

	%--
	% get annotation information
	%--
	
	if (length(fun))
		
		j = 1;
		
		for k = 1:length(fun)
			
			if findstr(fun{k},'_annotation')
				
				tmp = eval(file_ext(fun{k}));
				
				if (j == 1)
					PERSISTENT_ANNOT = tmp;
				else
					PERSISTENT_ANNOT(j) = tmp;
				end
				
				PERSISTENT_ANNOT_NAME{j} = tmp.name;
				
				j = j + 1;
				
			end
			
		end
		
	end
	
	%--
	% sort annotations by names
	%--
	
	[PERSISTENT_ANNOT_NAME,ix] = sort(PERSISTENT_ANNOT_NAME);
	
	PERSISTENT_ANNOT = PERSISTENT_ANNOT(ix);
	
end

%--
% output annotation structure array and annotation names
%--

ANNOT = PERSISTENT_ANNOT;

ANNOT_NAME = PERSISTENT_ANNOT_NAME;
