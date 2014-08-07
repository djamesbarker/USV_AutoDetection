function hist_kpfun(h)

% hist_kpfun - key press function for 1d histogram figure
% --------------------------------------------------------
%
% hist_kpfun(h)
%
% Input:
% ------
%  h - handle of figure

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
% $Date: 2003-10-08 22:51:15-04 $
% $Revision: 1.1 $
%--------------------------------

%--
% attach to figure
%--

if (nargin)
	set(h,'keypressfcn','hist_kpfun;');
end

%--
% get current character
%--

n = double(get(gcf,'currentcharacter'));

%--
% escape empty characters
%--

if (isempty(n))
	return;
end

%--
% perform command
%--

switch (n)
	
%--
% Histogram
%--

case (double('h'))
	hist_menu(gcf,'Histogram');
	
% bins

case (double('b'))
	hist_menu(gcf,'Other Number of Bins ...');
	
%--
% Kernel Estimate
%--

case(double('k'))
	hist_menu(gcf,'Kernel Estimate');
	
%--
% Fit
%--

case (double('f'))
	hist_menu(gcf,'Fit Model');
	
%--
% Grid
%--

case (double(':'))
	hist_menu(gcf,'Grid');
	
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
	
	ix = find(strcmp(get(data.browser.histogram(8:11),'check'),'on'));
	
	%--
	% update state based on keystroke
	%--
	
	switch (ix)
		
	% linear
	case (1)
		hist_menu(gcf,'Semi-Log X');
	
	% semi-log y
	case (2)
		hist_menu(gcf,'Log-Log');
		
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
	
	ix = find(strcmp(get(data.browser.histogram(8:11),'check'),'on'));
	
	%--
	% update state based on keystroke
	%--
	
	switch (ix)
		
	% semi-log x
	case (3)
		hist_menu(gcf,'Linear');
	
	% log-log
	case (4)
		hist_menu(gcf,'Semi-Log Y');
		
	end
	
%--
% up arrow
%--

case ({30,double('s')})
	
	%--
	% get userdata
	%--
	
	data = get(gcf,'userdata');
	
	%--
	% get current scale state
	%--
	
	ix = find(strcmp(get(data.browser.histogram(8:11),'check'),'on'));
	
	%--
	% update state based on keystroke
	%--
	
	switch (ix)
	
	% semi-log y
	case (2)
		hist_menu(gcf,'Linear');
		
	% log-log
	case (4)
		hist_menu(gcf,'Semi-Log X');
		
	end
	
%--
% down arrow
%--

case ({31,double('e')})
	
	%--
	% get userdata
	%--
	
	data = get(gcf,'userdata');
	
	%--
	% get current scale state
	%--
	
	ix = find(strcmp(get(data.browser.histogram(8:11),'check'),'on'));
	
	%--
	% update state based on keystroke
	%--
	
	switch (ix)
		
	% linear 
	case (1)
		hist_menu(gcf,'Semi-Log Y');
		
	% semi-log x	
	case (3)
		hist_menu(gcf,'Log-Log');
		
	end
	
%--
% Miscellanous
%--

case (double('r'))
	refresh(gcf);
	
case (double('t'))
	
	%--
	% get userdata
	%--
	
	data = get(gcf,'userdata');
	
	%--
	% resize based on number of axes
	%--
	
	switch (length(data.browser.axes))
		
	case (1)		
		pos = get(gcf,'position');
		set(gcf,'position',[pos(1:2) + (pos(3:4) - [600,600]),600,600]);
		
	otherwise
		pos = get(gcf,'position');
		set(gcf,'position',[pos(1:2) + (pos(3:4) - [600,900]),600,900]);
		
	end
	
end
