function fig_menu(h,str,flag)

% fig_menu - figure creation tools
% --------------------------------
%
% fig_menu(h,str,flag)
%
% Input:
% ------
%  h - figure handle (def: gcf)
%  str - menu command string (def: 'Initialize')
%  flag - enable flag option
	
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
% $Revision: 1.1 $
% $Date: 2004-03-30 17:35:03-05 $
%--------------------------------

%--
% enable flag option
%--

if (nargin == 3)	
	if (get_menu(h,'Fig'))
		set(get_menu(h,str),'enable',flag);
	end			
	return;			
end

%--
% set command string
%--

if (nargin < 2)
	str = 'Initialize';
end

%--
% perform command sequence
%--

if (iscell(str))
	for k = 1:length(str)
		try
			fig_menu(h,str{k}); 
		end
	end
	return;
end

%--
% set handle and figure tag
%--

if (nargin < 1)
	h = gcf;
end

set(h,'tag','FIG');

%--
% main switch
%--

switch (str)

%--
% Initialize
%--

case ('Initialize')
	
	%--
	% check for existing menu
	%--
	
	if (get_menu(h,'Fig'))
		return;
	end

	%--
	% get userdata
	%--
	
	if (~isempty(get(h,'userdata')))
		data = get(h,'userdata');
	end
	
	%--
	% Fig
	%--
	
% 	L = { ...
% 		'Fig', ...						
% 		'Edit Name and Caption ...', ...
% 		'Save Fig ...', ...	 			
% 		'Save Fig Options', ...	 	
% 		'Default', ...					
% 		'Orient Tall', ...			
% 		'Tight Bounding Box', ...	
% 		'Page Setup ...', ...
% 		'Print Preview ...', ...
% 		'Print ...', ...
% 		'Tile Figs', ...	
% 		'Figure Menubar', ...
%         'Close Fig' ...    
% 	};
% 	
% 
% 	n = length(L);
% 	
% 	S = bin2str(zeros(1,n));
% 	S{3} = 'on';
% 	S{5} = 'on';
% 	S{8} = 'on';
% 	S{11} = 'on';
% 	S{13} = 'on';
% 	
% 	A = cell(1,n);
% 	A{2} = 'F';
% 	A{3} = 'L';
% 	A{11} = 'T';
%     A{13} = 'W';

	L = { ...
		'Fig', ...						
		'Edit Name and Caption ...', ...
		'Save ...', ...	 			
		'Save Options', ...	 		
		'Page Setup ...', ...
		'Print Preview ...', ...
		'Print ...', ...
		'Cascade', ...
		'Tile', ...
		'Figure Menubar', ...
        'Close' ...    
	};
	

	n = length(L);
	
	S = bin2str(zeros(1,n));
	S{3} = 'on';
	S{5} = 'on';
	S{8} = 'on';
	S{end - 1} = 'on';
	S{end} = 'on';
	
	A = cell(1,n);
	A{2} = 'F';
	A{3} = 'L';
	A{8} = 'R';
	A{9} = 'T';
    A{end} = 'W';
	
	data.fig.fig = ...
		menu_group(h,'fig_menu',L,S,A);	
	
	%--
	% Save Fig Options
	%--
	
	L = { ...
		'Create Fig', ...
		'EPS', ...
		'EPS Color', ...
		'LaTeX', ...
		'LaTeX Options' ...
	};
	
	n = length(L);
	
	S = bin2str(zeros(1,n));
	S{2} = 'on';
	S{4} = 'on';
	
	A = cell(1,n);
	
	data.fig.save_options = ...
		menu_group(get_menu(h,'Save Options'),'fig_menu',L,S,A);
	
	%--
	% LaTeX Options
	%--
	
	L = { ...
		'Use PSfrag', ...	
		'Create Preview File', ...
	};
	
	n = length(L);
	
	S = bin2str(zeros(1,n));
	
	A = cell(1,n);
	
	data.fig.latex_options = ...
		menu_group(get_menu(h,'LaTeX Options'),'fig_menu',L,S,A);
		
	%--
	% set parameters
	%--

	data.fig.name = ['fig' num2str(h)];
	data.fig.short = 'Put short caption here.';
	data.fig.caption = 'Put caption here.';
	data.fig.textwidth = '5.8';
	data.fig.textheight = '8.8';
	
	data.fig.fig = 0;
	data.fig.latex = 0;
	data.fig.psfrag = 0;
	data.fig.preview = 0;
	
	%--
	% set userdata
	%--
	
	set(h,'userdata',data);
	
	%--
	% set defaults
	%--
	
	set(h,'Name',data.fig.name);
	
	fig_menu(h,'Default');
	fig_menu(h,'Create Fig')
	fig_menu(h,'EPS Color');
	fig_menu(h,'LaTeX');
	fig_menu(h,'Use PSfrag');
	fig_menu(h,'Create Preview File');
			
%--
% Name and Caption ...
%--

case ('Edit Name and Caption ...')

	% get userdata
	
	data = get(h,'userdata');
	f = data.fig;
	
	% setup edit dialog and get name and captions

	ans = input_dialog( ...
		{'Name (used as filename)','Short Caption','Caption'}, ...
		'Edit Name and Caption ...', ...
		[1, 60; 2, 60; 10, 60], ...
		{f.name, f.short, f.caption} ...
	);
	
	if (~isempty(ans))
		set(h,'Name',ans{1});
		data.fig.name = ans{1};
		data.fig.short = ans{2};
		data.fig.caption = ans{3};
	end
	
	% update userdata
	
	set(h,'userdata',data);		

%--
% Save ...
%--

case ('Save ...')

	%--
	% get userdata
	%--
	
	data = get(h,'userdata');
	f = data.fig;
	
	%--
	% save fig as LaTeX or EPS
	%--
	
	if (f.latex)
		
		% set EPS and LaTeX options
		
		opt.eps = f.eps;
		
		opt.psfrag = f.psfrag;
		opt.preview = f.preview;	
		
		% save fig
		
		F = figs_tex(h,opt);
		
	else
		
		% set EPS options
		
		opt = f.eps;
		
		% save fig
		
		F = figs_eps(h,opt);
		
	end
	
	%--
	% create fig file
	%--
	
	if (f.fig)
		fig_save(h,file_ext(F,'fig'));
	end
	
%--
% Create Fig
%--

case ('Create Fig')
	
	%--
	% get userdata
	%--
	
	data = get(h,'userdata');
	
	%--
	% update userdata and menu
	%--
	
	data.fig.fig = ~data.fig.fig;
	set(h,'userdata',data); 
	
	if (data.fig.fig)
		set(get_menu(h,'Create Fig'),'check','on');
	else
		set(get_menu(h,'Create Fig'),'check','off');
	end
	
%--
% EPS
%--

case ('EPS')

	% get userdata
	
	data = get(h,'userdata');
	
	% update parameter and check
	
	data.fig.eps = 'deps';
	
	set(get_menu(h,'EPS'),'check','on');
	set(get_menu(h,'EPS Color'),'check','off');
	
	% update userdata
	
	set(h,'userdata',data);
	
%--
% EPS Color
%--

case ('EPS Color')
	
	% get userdata
	
	data = get(h,'userdata');
	
	% update parameter and check
	
	data.fig.eps = 'depsc';
	
	set(get_menu(h,'EPS Color'),'check','on');
	set(get_menu(h,'EPS'),'check','off');
	
	% update userdata
	
	set(h,'userdata',data);
	
%--
% LaTeX
%--

case ('LaTeX')

	% get userdata
	
	data = get(h,'userdata');
	
	% toggle parameter and check
	
	data.fig.latex = ~data.fig.latex;
	
	if (data.fig.latex)
		set(get_menu(h,'LaTeX'),'check','on');
	else
		set(get_menu(h,'LaTeX'),'check','off');
	end
	
	% update userdata
	
	set(h,'userdata',data);
	
%--
% Use PSfrag
%--

case ('Use PSfrag')

	% get userdata
	
	data = get(h,'userdata');
	
	% toggle parameter and check
	
	data.fig.psfrag = ~data.fig.psfrag;
	
	if (data.fig.psfrag)
		set(get_menu(h,'Use PSfrag'),'check','on');
	else
		set(get_menu(h,'Use PSfrag'),'check','off');
	end
	
	% update userdata
	
	set(h,'userdata',data);
	
%--
% Create Preview File
%--

case ('Create Preview File')

	% get userdata
	
	data = get(h,'userdata');
	
	% toggle parameter and check
	
	data.fig.preview = ~data.fig.preview;
	
	if (data.fig.preview)
		set(get_menu(h,'Create Preview File'),'check','on');
	else
		set(get_menu(h,'Create Preview File'),'check','off');
	end
	
	% update userdata
	
	set(h,'userdata',data);
	
%--
% Default
%--

case ('Default')
	
	% get userdata
	
	data = get(h,'userdata');
	
	% set paperposition
	
	p = get(0,'DefaultFigurePaperposition');
	set(h,'paperposition',p);
	
	% update checks
	
	set(get_menu(h,'Default'),'check','on');
	set(get_menu(h,'Orient Tall'),'check','off');
	set(get_menu(h,'Tight Bounding Box'),'check','off');
	
%--
% Orient Tall
%--

case ('Orient Tall')

	% get userdata
	
	data = get(h,'userdata');
	
	% set paperposition
	
	orient tall;
	
	% update checks
	
	set(get_menu(h,'Default'),'check','off');
	set(get_menu(h,'Orient Tall'),'check','on');
	set(get_menu(h,'Tight Bounding Box'),'check','off');
	
%--
% Tight Bounding Box
%--

case ('Tight Bounding Box')

	% get userdata
	
	data = get(h,'userdata');
	f = data.fig;
	
	% get size of image
	
	g = get_image_handles(h);
	
	switch (length(g))
		
	case (0)
		warning('''Tight Bounding Box'' option is not available for non-image figures.');
		return;
		
	case (1)
		[m,n] = size(get(g,'CData'));
		
	otherwise
		if (length(g) > 1)
			warning('''Tight Bounding Box'' option is not available for multiple image figures.');
			return;
		end
		
	end 
	
	% compute and set paperposition
	
	S = get(h,'papersize');
	
	W = str2num(f.textwidth);
	H = str2num(f.textheight);
	
	X = (S(1) - W) / 2;
	Y = (S(2) - H) / 2;

	if ((m / n) >= (H / W))		
		pos = [X, Y, (3/4)*H*(m / n), (3/4)*H];
	else	
		pos = [X, Y, W, W*(m / n)];	
	end
	
	set(h,'paperposition',pos);
			
	% update checks
	
	set(get_menu(h,'Default'),'check','off');
	set(get_menu(h,'Orient Tall'),'check','off');
	set(get_menu(h,'Tight Bounding Box'),'check','on');
    
%--
% Page Layout ...
%--

case ('Page Layout ...')
	
	pagedlg(h);
	
%--
% Page Setup ...
%--

case ('Page Setup ...')
	
	pagesetupdlg(h);
	
%--
% Print Preview ...
%--

case ('Print Preview ...')
	
	printpreview(h); 

%--
% Print ...
%--

case ('Print ...')
	
	printdlg(h);
	
%--
% Figure Menubar
%--

case ('Figure Menubar')
	
	%--
	% toggle figure menubar
	%--
	
	figure_menubar(h);
	
	%--
	% update menu
	%--
	
	if (strcmp(get(h,'menubar'),'none'))
		set(get_menu(h,'Figure Menubar'),'check','off');
	else
		set(get_menu(h,'Figure Menubar'),'check','on');
	end
	
%--
% Cascade
%--

case ('Cascade')
	
	figs_cascade;
	
%--
% Tile
%--

case ('Tile')
	
	figs_tile;
	
%--
% Close
%--

case ('Close')

    close(h);
			
end
	
	
	
	
