function [G, X] = file_ext(F, x)

% file_ext - set or strip file extensions
% ---------------------------------------
%
% [G, X] = file_ext(F, x)
%
% Input:
% ------
%  F - input strings
%  x - extension string (def: '' (remove extensions))
%
% Output:
% -------
%  G - strings with extensions
%  X - input extensions when extensions are stripped

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
% $Revision: 698 $
% $Date: 2005-03-11 16:20:26 -0500 (Fri, 11 Mar 2005) $
%--------------------------------

%--
% set default extension (strip extensions)
%--

if nargin < 2
	x = '';
end

%--
% put string into cell
%--

if ischar(F)
	F = {F}; flag = 1;
else
	flag = 0;
end

%--
% strip extension
%--

if isempty(x)
	
	G = cell(size(F)); X = cell(size(F));
	
	for k = 1:length(F)
		
		% NOTE: this is a specialized test to handle backup log files (no longer used)

		ixa = findstr(F{k}, '@');
		
		if isempty(ixa)
			
			%--
			% this is the branch that handles the general file extension
			%--
			
			ix = findstr(F{k}, '.');
			
			if isempty(ix)
				G{k} = F{k}; X{k} = '';
			else
            	G{k} = F{k}(1:(ix(end) - 1)); X{k} = F{k}((ix(end) + 1):end);
			end
			
		else
			
			% NOTE: for backup logs just remove the extension and keep name date
			
			G{k} = strrep(F{k}, '.mat', '');
			
		end
		
	end
	
%--
% set extensions
%--

else

	%--
	% add extension
	%--

	G = cell(size(F));
		
	for k = 1:length(F)
		
		ix = findstr(F{k}, '.');
		
		if isempty(ix)
			s = F{k};
		else
            s = F{k}(1:(ix(end) - 1));
		end
		
		G{k} = [s, '.', x];	
		
	end
	
	%--
	% output empty input extensions in this case
	%--
	
	X = [];
	
end

%--
% output string
%--

% NOTE: modification of output type is not a good idea although convenient

if flag
	G = G{1}; X = X{1};
end

