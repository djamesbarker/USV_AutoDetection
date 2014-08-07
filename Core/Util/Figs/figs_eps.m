function [F,d] = figs_eps(h,opt,d)

% figs_eps - save figures as color eps files
% ------------------------------------------
%
% [F,d] = figs_eps(h,opt,d)
%
% Input:
% ------
%  h - figure handles
%  opt - eps creation option
%  d - destination directory (def: uiputfile)
%
% Output:
% -------
%  F - names of files created
%  d - destination directory

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
% $Date: 2003-09-16 01:30:50-04 $
%--------------------------------

%--
% get destination directory
%--

if ((nargin < 3) | isempty(d))
	[t,d] = uiputfile('*.eps','Select destination directory:');
end

%--
% set eps options
%--

if (nargin < 2)
	opt = 'depsc';
end

%--
% set figure handles
%--

if ((nargin < 1) | isempty(h))
	h = get_figs;
end

%--
% save figures
%--

flag = 0;

for k = 1:length(h)

	% get and construct filename
	
	F{k} = [fig_name(h(k)) '.eps'];
	
	% create eps file

	eval(['print ''' d F{k} ''' -' opt ' -cmyk -adobecset -f' num2str(h(k))]);
% 	eval(['print ''' d F{k} ''' -' opt ' -cmyk -f' num2str(h(k))]);
	
end

%--
% output string
%--

if (length(F) == 1)
	F = F{1};
end
