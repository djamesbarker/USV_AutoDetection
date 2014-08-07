function h = se_view(SE,r)

% se_view - view structuring element 
% ----------------------------------
% 
% h = se_view(SE)
%
% Input:
% ------
%  SE - structuring element
%  r - radius of ball to display
%
% Output:
% -------
%  h - handle to display axes 

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

%--
% relax support and put SE in matrix representation
%--

SE = se_loose(SE,[1,1]);

%--
% display image of SE
%--

imagesc(SE,[0 1]);

colormap([0 0 0; 1 1 1]);
axis('image');

%--
% keep axes handle and set hold on
%--

h = gca;

hold on;

%--
% set up grid
%--

pq = se_supp(SE);

image_grid(0:2*pq(1),0:2*pq(2));

set(h,'YTickLabel',[]);
set(h,'XTickLabel',[]);

grid on;

% set(h,'YColor',0.5*[1 1 1]);
% set(h,'XColor',0.5*[1 1 1]);

set(h,'YColor',0.0*[1 1 1]);
set(h,'XColor',0.0*[1 1 1]);


%--
% display center of structuring element
%--

c = pq + 1;

scatter(c(2),c(1),'go','filled');

% if (SE(c(1),c(2)) == 1)
% 	scatter(c(2),c(1),'ro','filled');
% else
% 	scatter(c(2),c(1),'ro');
% end
%
% set(hm,'LineWidth',2);

%--
% display centroid of structuring element
%--

% the visual suggestion is that the centroid starts on green (unripe)
% before selection, and stops on red (ripens) upon selection

md = c + se_cent(SE);

scatter(md(2),md(1),'ro','filled');

% if (SE(round(md(1)),round(md(2))) == 1)
% 	scatter(md(2),md(1),'go','filled');
% else
% 	scatter(md(2),md(1),'go','filled');
% end

% set(hm,'LineWidth',2);

%--
% display enclosing ball with structuring element
%--

if (nargin > 1)
	
	t = linspace(0,2*pi);
	plot((r * cos(t) + pq(2) + 1),(r * sin(t) + pq(1) + 1),'color',0.5 * [1,1,1]);
	
end

%--
% title image
%--

if (~isempty(inputname(1)))		
	title_edit(['Structuring Element: ' strrep(inputname(1),'_','\_')]);	
else	
	title_edit('Structuring Element: [inputname(1)]');	
end

xlabel_edit(['Support: [' num2str(pq(1) - 1) ', ' num2str(pq(2) - 1) '], Size: ' num2str(se_size(SE))]);
