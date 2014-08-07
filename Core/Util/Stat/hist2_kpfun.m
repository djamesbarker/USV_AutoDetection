function hist2_kpfun(h,c)

% hist2_kpfun - key press function for 2d histogram figure
% --------------------------------------------------------
%
% hist2_kpfun(h,c)
%
% Input:
% ------
%  h - handle of figure
%  c - command key

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
% $Date: 2003-09-16 01:32:04-04 $
% $Revision: 1.0 $
%--------------------------------

%--
% attach to figure
%--

if (nargin)
	set(h,'keypressfcn','hist2_kpfun;');
end

%--
% get current character
%--

if (nargin < 2)
	c = double(get(gcf,'currentcharacter'));
end

%--
% escape empty characters
%--

if (isempty(c))
	return;
end

%--
% perform command
%--

switch (c)
	
%--
% Histogram
%--

case (double('h'))
	hist2_menu(gcf,'Histogram');
	
% % bins
% 
% case (double('b'))
% 	hist2_menu(gcf,'Other Number of Bins ...');
	
%--
% Kernel Estimate
%--

case(double('k'))
	hist2_menu(gcf,'Kernel Estimate');
	
%--
% Fit
%--

case (double('f'))
	hist2_menu(gcf,'Fit Model');
	
%--
% Grid
%--

case (double(':'))
	hist2_menu(gcf,'Grid');
	
%--
% Scale
%--

% back arrow
case (28)
	
	%--
	% get userdata
	%--
	
	data = get(gcf,'userdata');
	
	%--
	% get current scale state
	%--
	
	ix = find(strcmp(get(data.hist2_menu.histogram(8:11),'check'),'on'));
	
	%--
	% update state based on keystroke
	%--
	
	switch (ix)
		
	% linear
	case (1)
		hist2_menu(gcf,'Semi-Log X');
	
	% semi-log y
	case (2)
		hist2_menu(gcf,'Log-Log');
		
	end
	
	
% forward arrow
case (29)
	
	%--
	% get userdata
	%--
	
	data = get(gcf,'userdata');
	
	%--
	% get current scale state
	%--
	
	ix = find(strcmp(get(data.hist2_menu.histogram(8:11),'check'),'on'));
	
	%--
	% update state based on keystroke
	%--
	
	switch (ix)
		
	% semi-log x
	case (3)
		hist2_menu(gcf,'Linear');
	
	% log-log
	case (4)
		hist2_menu(gcf,'Semi-Log Y');
		
	end
	
% up arrow
case (30)
	
	%--
	% get userdata
	%--
	
	data = get(gcf,'userdata');
	
	%--
	% get current scale state
	%--
	
	ix = find(strcmp(get(data.hist2_menu.histogram(8:11),'check'),'on'));
	
	%--
	% update state based on keystroke
	%--
	
	switch (ix)
	
	% semi-log y
	case (2)
		hist2_menu(gcf,'Linear');
		
	% log-log
	case (4)
		hist2_menu(gcf,'Semi-Log X');
		
	end
	
% down arrow
case (31)
	
	%--
	% get userdata
	%--
	
	data = get(gcf,'userdata');
	
	%--
	% get current scale state
	%--
	
	ix = find(strcmp(get(data.hist2_menu.histogram(8:11),'check'),'on'));
	
	%--
	% update state based on keystroke
	%--
	
	switch (ix)
		
	% linear 
	case (1)
		hist2_menu(gcf,'Semi-Log Y');
		
	% semi-log x	
	case (3)
		hist2_menu(gcf,'Log-Log');
		
	end
%--
% Colormap
%--

case (double('G'))
	if (~isempty(findobj(gcf,'type','uimenu','label','Grayscale')))
		hist2_menu(gcf,'Grayscale');
	end
	
case (double('H'))
	if (~isempty(findobj(gcf,'type','uimenu','label','Hot')))
		hist2_menu(gcf,'Hot');
	end
	
case (double('J'))
	if (~isempty(findobj(gcf,'type','uimenu','label','Jet')))
		hist2_menu(gcf,'Jet');
	end
	
case (double('B'))
	if (~isempty(findobj(gcf,'type','uimenu','label','Bone')))
		hist2_menu(gcf,'Bone');
	end
	
case (double('V'))
	if (~isempty(findobj(gcf,'type','uimenu','label','HSV')))
		hist2_menu(gcf,'HSV');
	end
	
%--
% Colormap Options
%--

case (double('c'))
	if (~isempty(findobj(gcf,'type','uimenu','label','Colorbar')))
		hist2_menu(gcf,'Colorbar');
		hist2_kpfun(gcf,'t');
	end
	
case (double('d'))
	if (~isempty(findobj(gcf,'type','uimenu','label','Darken')))
		hist2_menu(gcf,'Darken');
	end
	
case (double('b'))
	if (~isempty(findobj(gcf,'type','uimenu','label','Brighten')))
		hist2_menu(gcf,'Brighten');
	end
	
case (double('i'))
	if (~isempty(findobj(gcf,'type','uimenu','label','Invert')))
		hist2_menu(gcf,'Invert');
	end
	
%--
% Miscellanous
%--

case (double('t'))
	data = get(gcf,'userdata');
	ax = data.hist2_menu.axes;
	axes(ax.xy);
	truesize(gcf,[300,300]);
	
end
