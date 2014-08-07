function browser = xhist_create(varargin)

% xhist_create - create histogram explorer structure
% -----------------------------------------------
%
% browser = xhist_create
%
% Output:
% -------
%  browser - density browser structure

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
% $Date: 2003-09-16 01:32:07-04 $
%--------------------------------

%---------------------------------------------------------------------
% CREATE DENSITY BROWSER STRUCTURE
%---------------------------------------------------------------------

persistent HIST_PERSISTENT;

if (isempty(HIST_PERSISTENT))
	
	%--------------------------------------------
	% DATA AND HISTOGRAM COMPUTATION FIELDS
	%--------------------------------------------

	%--
	% input data
	%--
	
	browser.data = [];
	
	%--
	% histogram bounds and mask
	%--
	
	browser.bounds = [];
	
	browser.mask = [];
	
	%--
	% data summaries
	%--
	
	browser.summary = []; % data summaries
	
	%--------------------------------------------
	% HISTOGRAM FIELDS
	%--------------------------------------------
	
	%--
	% histogram elements
	%--
		
	hist.bins = []; % number of bins
	
	hist.counts = []; % bin counts
	
	hist.centers = []; % bin centers
	
	hist.breaks = []; % bin breaks
	
	%--
	% histogram display
	%--
	
	hist.view = 1;
	
	hist.color = 'Gray';
	
	hist.linestyle = 'Dot';
	
	hist.linewidth = 1;
	
	hist.patch = -1; % 0.25;
	
	browser.hist = hist;
			
	%--
	% kernel fit computation and display options
	%--
	
	kernel.view = 1;
	
	kernel.length = 1/8;
	
	kernel.type = 'Tukey';
	
	kernel.color = 'Black';
	
	kernel.linestyle = 'Solid';
	
	kernel.linewidth = 1;
	
	kernel.patch = -1; % 0.25;
	
	browser.kernel = kernel;
	
	%--
	% model fit computation and display options
	%--
	
	fit.view = 0;
	
	fit.model = 'Generalized Gaussian';
	
	fit.color = 'Red';
	
	fit.linestyle = 'Dash';
	
	fit.linewidth = 1;
	
	fit.patch = -1; % 0.25;

	browser.fit = fit;
	
	%------------------------------------------
	% GENERAL DISPLAY FIELDS
	%------------------------------------------
	
	%--
	% displayed axes and scaling
	%--
	
	browser.axes = []; % histogram display axes
	
	browser.scale = 'Linear'; % axes scaling
	
	browser.lines.hist = []; % histogram lines
	
	browser.lines.kernel = []; % kernel fit lines
	
	browser.lines.fit = []; % model fit lines
	
	%--
	% grid fields
	%--
	
	browser.grid.on = 0;
	
	browser.grid.color = 'Dark Gray';
	
	browser.grid.x = 0;
	
	browser.grid.y = 0;
		
	%------------------------------------------
	% RELATED WINDOW FIELDS
	%------------------------------------------
	
	browser.children = [];
	
	browser.palettes = [];
	
	%--
	% set persistent density browser
	%--
	
	HIST_PERSISTENT = browser;

else
	
	%--
	% copy persistent density browser structure
	%--
	
	browser = HIST_PERSISTENT;
		
end

%---------------------------------------------------------------------
% SET FIELDS IF PROVIDED
%---------------------------------------------------------------------

if (length(varargin))
	browser = parse_inputs(browser,varargin{:});
end



