function h = fig(m,n,k)

% fig - create figure with fig menu
% ---------------------------------
%
% h = fig(m,n,k)
%
% Input:
% ------
%  m,n - figure rows and columns
%  k - position
%
% Output:
% -------
%  h - handle to figure

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
% $Revision: 1.0 $
% $Date: 2003-09-16 01:30:52-04 $
%--------------------------------

% TODO: allow configuration of tools available, say only tile and cascade

%--
% handle variable input
%--

switch (nargin)

	%--
	% default size fig
	%--
	
	case (0)
		
		h = figure;
		
		set(h, ...
			'tag','FIG', ...
			'doublebuffer','on', ...
			'backingstore','on' ...	
		);
	
		fig_menu(h);
		
	%--
	% grid positioned figure
	%--
	
	case (3)
		
		h = figure;
		
		set(h, ...
			'tag','FIG', ...
			'doublebuffer','on', ...
			'backingstore','on' ...	
		);
	
		fig_sub(m,n,k,h);	
		
		fig_menu(h);
	
end
