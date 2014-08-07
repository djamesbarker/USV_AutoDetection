function [T,R,A] = fig_psfrag(h,T,R)

% fig_psfrag - tool for creating psfrag annotated fig
% ---------------------------------------------------
%
% [T,R,A] = fig_psfrag(h);
%       = fig_psfrag(h,T,R);
%
% Input:
% ------
%  h - figure handle
%  T - tags
%  R - text to replace
%
% Output:
% -------
%  T - tags
%  R - replaced text
%  A - alignment of replacements

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
% $Date: 2004-02-11 06:56:07-05 $
%--------------------------------

% f = 'sf';
f = '';

%--
% set figure
%--

if (nargin < 1)
	h = gcf;
end

%--
% handle variable input
%--

switch (nargin)

	%--
	% replace text by psfrag tags
	%--
	
	case (1)
		
		%--
		% get default font
		%--
		
		font = get(0,'DefaultAxesFontName');
		
		%--
		% get axes
		%--
		
		ax = findobj(h,'type','axes');
		
		%--
		% replace text with tags and set font (conversion to PDF problem)
		%--
		
		% tag counter
		
		n = 1;
		
		% loop over axes
		
		for k = 1:length(ax)
				
			%--
			% title
			%--
			
			g = get(ax(k),'title');			
			s = get(g,'string');
			
			if (length(s))
				T{n} = ['T' n2s(k)];
				R{n} = s;
% 				if (isempty(f))
% 					R{n} = s;
% 				else
% 					R{n} = ['{\' f ' ' s '}'];
% 				end
				A{n} = '[][]';
				set(g,'string',T{n},'fontname',font);
				n = n + 1;
			end
			
			drawnow;
			
			% ylabel and yticklabel
			
			g = get(ax(k),'ylabel');
			s = get(g,'string');
			
			if (length(s))
				T{n} = ['YL' n2s(k)];
				R{n} = s;
% 				if (isempty(f))
% 					R{n} = s;
% 				else
% 					R{n} = ['{\' f ' ' s '}'];
% 				end
				A{n} = '[][]';
				set(g,'string',T{n},'fontname',font);
				n = n + 1;
			end
			
% 			if (~isempty(get(ax(k),'ytick')))
% 				
% 				yl = cellstr(get(ax(k),'yticklabel'));
% 				
% 				for j = 1:length(yl)
% 					if (length(yl{j}))
% 						T{n} = ['y' n2s(k) n2s(j)];
% 						if (isempty(f))
% 							R{n} = yl{j};
% 						else
% 							R{n} = ['{\' f ' ' yl{j} '}'];
% 						end
% 						if (strcmp(get(ax(k),'yaxislocation'),'left'))
% 							A{n} = '[Br][Br]';
% 						else
% 							A{n} = '[Bl][Bl]';
% 						end
% 						yl{j} = T{n};
% 						n = n + 1;
% 					end
% 				end
% 				
% 				set(ax(k),'yticklabel',yl,'fontname',font);
% 				
% 			end
			
			% xlabel and xticklabel
				
			g = get(ax(k),'xlabel');
			s = get(g,'string');
			
			if (length(s))
				T{n} = ['XL' n2s(k)];
				R{n} = s;
% 				if (isempty(f))
% 					R{n} = s;
% 				else
% 					R{n} = ['{\' f ' ' s '}'];
% 				end
				A{n} = '[][]';
				set(g,'string',T{n},'fontname',font);
				n = n + 1;
			end
			
% 			if (~isempty(get(ax(k),'xtick')))
% 				
% 				xl = cellstr(get(ax(k),'xticklabel'));
% 			
% 				for j = 1:length(xl)
% 					if (length(xl{j}))
% 						T{n} = ['x' n2s(k) n2s(j)];
% 						if (isempty(f))
% 							R{n} = xl{j};
% 						else
% 							R{n} = ['{\' f ' ' xl{j} '}'];
% 						end
% 						A{n} = '[][]';
% 						xl{j} = T{n};
% 						n = n + 1;
% 					end
% 				end
% 				
% 				set(ax(k),'xticklabel',xl,'fontname',font);
% 				
% 			end
			
		end
		
		% text objects
		
		g = findobj(h,'type','text');
		
		c = 65;
		
		for k = 1:length(g)
		
			s = get(g(k),'string');
		
			if (length(s))
				T{n} = char(c);
				R{n} = s;
% 				if (isempty(f))
% 					R{n} = s;
% 				else
% 					R{n} = ['{\' f ' ' s '}'];
% 				end
				A{n} = '[][]';
				set(g(k),'string',T{n},'fontname',font);
				n = n + 1;
				c = c + 1;		
			end
			
		end

	%--
	% replace psfrag tags by text
	%--
	
	case (3)
		
		%--
		% get default font
		%--
		
		font = get(0,'DefaultAxesFontName');
		
		%--
		% get axes
		%--
		
		ax = findobj(h,'type','axes');
		
		%--
		% replace tags with text
		%--
		
		% loop over axes
		
		for k = 1:length(ax)
		
			% title
			
			g = get(ax(k),'title');			
			s = get(g,'string');
			
			if (length(s))
				ix = find(strcmp(T,s));
				set(g,'string',R{ix},'fontname',font);
			end
			
			% ylabel and yticklabel
			
			g = get(ax(k),'ylabel');
			s = get(g,'string');
			
			if (length(s))
				ix = find(strcmp(T,s));
				set(g,'string',R{ix},'fontname',font);
			end
			
% 			if (~isempty(get(ax(k),'ytick')))
% 				
% 				yl = cellstr(get(ax(k),'yticklabel'));
% 				
% 				for j = 1:length(yl)
% 					if (length(yl{j}))
% 						ix = find(strcmp(T,yl{j}));
% 						yl{j} = R{ix};
% 					end
% 				end
% 				
% 				set(ax(k),'yticklabel',yl,'fontname',font);
% 				
% 			end
			
			% xlabel and xticklabel
			
			g = get(ax(k),'xlabel');
			s = get(g,'string');
			
			if (length(s))
				ix = find(strcmp(T,s));
				set(g,'string',R{ix},'fontname',font);
			end
			
% 			if (~isempty(get(ax(k),'xtick')))
% 				
% 				xl = cellstr(get(ax(k),'xticklabel'));
% 				
% 				for j = 1:length(xl)
% 					if (length(xl{j}))
% 						ix = find(strcmp(T,xl{j}));
% 						xl{j} = R{ix};
% 					end
% 				end
% 				
% 				set(ax(k),'xticklabel',xl,'fontname',font);
% 				
% 			end
			
		end
		
		% text objects
			
		g = findobj(h,'type','text');
		
		for k = 1:length(g)
		
			s = get(g(k),'string');
		
			if (length(s))
				ix = find(strcmp(T,s));
				set(g,'string',R{ix},'fontname',font);
			end
			
		end
				
end

% n2s - two digit number strings
% -------------------------------
% 
% s = n2s(n)
%
% Input:
% ------
%  n - integer > 0 and < 100
%
% Output:
% -------
%  s - two digit string

function s = n2s(n)

% check range

if ((n < 1) | (n > 99))
	error('Number to convert must be > 0 and < 100.');
end

% convert padding small numbers

if (n < 10)
	s = ['0' num2str(n)];
else
	s = num2str(n);
end


