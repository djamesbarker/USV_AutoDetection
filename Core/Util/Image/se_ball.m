function SE = se_ball(r,p,t)

% se_ball - norm ball structuring element
% ---------------------------------------
% 
% SE = se_ball(r,p,t)
%
% Input:
% ------
%  r - ball radius (def: [3,3])
%  p - norm exponent (def: 2)
%  t - rotation (def: 0)
%
% Output:
% -------
%  SE - structuring element

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
% $Revision: 1814 $
% $Date: 2005-09-21 15:24:01 -0400 (Wed, 21 Sep 2005) $
%--------------------------------

%------------------------------------------
% HANDLE INPUT 
%------------------------------------------

%--
% set rotation angle
%--

if ((nargin < 3) || isempty(t))
	t = 0;
end

%--
% set exponent
%--

if ((nargin < 2) || isempty(p))
	p = 2;
end

%--
% set radius
%--

if ((nargin < 1) || isempty(r))
	r = [3,3];
else
	if (length(r) == 1)
		r = [r, r];
	end
end

%--
% handle degenerate balls
%--

% the case of rotated degenerate balls is not handled properly

if (min(r) == 0)
	
	if (max(r) == 0)
		
		SE = 1;
		
	elseif (r(1) == 0)
		
		tmp = round(2*r(2) + 1);
		
		if (~mod(tmp,2))
			tmp = tmp + 1;
		end
		
		SE = ones(tmp,1);
		
	elseif (r(2) == 0)
		
		tmp = round(2*r(1) + 1);
		
		if (~mod(tmp,2))
			tmp = tmp + 1;
		end
		
		SE = ones(1,tmp);
		
	end
	
	return;
	
end
		
%------------------------------------------
% EVALUATE BALL INDICATOR
%------------------------------------------

%--
% create evaluation grid
%--

R = 4*max(ceil(r));

n = 2*R + 1;

X = repmat(-R:R,[n,1]);

Y = flipud(X');

%--
% rotate grid if needed
%--

if (t ~= 0)
	
	A = [cos(-t) -sin(-t); sin(-t) cos(-t)];
	
	tmp = A * [X(:)'; Y(:)'];
	
	X = reshape(tmp(1,:),n,n);
	
	Y = reshape(tmp(2,:),n,n);
	
end

%--
% evalute axis aligned function
%--

f = max(r);

f = sqrt(f^2 + 2) / f;

SE = (abs(X./r(1)).^p + abs(Y./r(2)).^p).^(1/p) <= f;

SE = double(SE);

%--
% tighten result
%--

SE = se_tight(SE);

%------------------------------------------
% OLD SE_BALL
%------------------------------------------

% function SE = se_ball(d,p,s,t)
% 
% % se_ball - norm ball structuring element
% % ---------------------------------------
% % 
% % SE = se_ball(d,p,s,t)
% %
% % Input:
% % ------
% %  d - norm bound
% %  p - norm exponent (def: 2)
% %  s - axis scaling (def: 1)
% %  t - rotation (def: 0)
% %
% % Output:
% % -------
% %  SE - structuring element
% 
% %--------------------------------
% % Author: Harold Figueroa
% %--------------------------------
% % $Revision: 1814 $
% % $Date: 2005-09-21 15:24:01 -0400 (Wed, 21 Sep 2005) $
% %--------------------------------
% 
% %--
% % set rotation
% %--
% 
% if (nargin < 4)
% 	t = [];
% end
% 
% %--
% % set scale
% %--
% 
% if (nargin < 3)
% 	s = [];
% end
% 
% %--
% % set norm
% %--
% 
% if (nargin < 2)
% 	p = 2;
% end
%  
% %--
% % modify norm bound
% %--
% 
% % d = d*(1 + 0.075);
% 
% %--
% % create unit 'norm' circle
% %--
% 
% x = linspace(0,2*pi,2048);
% x = [cos(x); sin(x)];
% 
% x = (x./([1; 1]*(abs(x(1,:)).^p + abs(x(2,:)).^p).^(1/p)));
% 
% %--
% % scale and rotate circle
% %--
% 
% A = eye(2);
% 
% if (~isempty(s))
% 	A = diag([s, 1/s]);
% end
% 
% if (~isempty(t))
% 	A = [cos(t) -sin(t); sin(t) cos(t)]*A;
% end
% 
% if ((~isempty(s)) || (~isempty(t)))
% 	y = A*(d*x);
% else
% 	y = d*x;
% end
% 
% %--
% % get integer points inside and outside of ball
% %--
% 
% zx = floor(min(y(1,:))):ceil(max(y(1,:)));
% zy = floor(min(y(2,:))):ceil(max(y(2,:)));
% 
% z = [vec_col(ones(length(zy),1)*zx)'; vec_col(zy'*ones(1,length(zx)))'];
% 
% if ((~isempty(s)) || (~isempty(t)))
% 	w = A\z;
% else
% 	w = z;
% end
% 
% if (~nargout)
% 	r = z(:,find((abs(w(1,:)).^p + abs(w(2,:)).^p).^(1/p) > d));
% end
% 
% z = z(:,find((abs(w(1,:)).^p + abs(w(2,:)).^p).^(1/p) <= d));
% 
% %--
% % create structuring element
% %--
% 
% SE = se_mat(fliplr(z'));
% 
% %--
% % plot balls and structuring element
% %--
% 
% if (~nargout)
% 	
% 	%--
% 	% plot display of structuring element
% 	%--
% 	
% 	fig;
% 	hold on;
% 
% 	% boundaries
% 	
% % 	plot(x(1,:),x(2,:),'k:');
% 	plot(y(1,:),y(2,:),'k:');
% 	
% 	% pixels
% 	
% 	scatter(z(1,:),z(2,:),'ko','filled');
% 	scatter(r(1,:),r(2,:),'ko');
% 	
% 	axis('ij');
% 	axis('equal');
% 
% 	pq = se_supp(SE);
% 
% 	h = gca;
% 	
% 	%--
% 	% set pixel grid
% 	%--
% 	
% 	g = [min(z(1,:)) - 1, max(z(1,:)) + 1, min(z(2,:)) - 1, max(z(2,:)) + 1];
%  	image_grid(g(3):g(4),g(1):g(2));
% 	
% 	set(h,'YTickLabel',[]);
% 	set(h,'XTickLabel',[]);
% 	
% 	set(h,'box','on');
% 
% 	%--
% 	% display center of structuring element
% 	%--
% 
% 	c = pq + 1;
% 	
% 	scatter(0,0,'ro','filled');
% 
% % 	if (SE(c(1),c(2)) == 1)
% % 		hm = scatter(0,0,'ro','filled');
% % 	else
% % 		hm = scatter(0,0,'ro');
% % 	end
% %
% %	set(hm,'LineWidth',2);
% 
% 	%--
% 	% display centroid of structuring element
% 	%--
% 
% % 	c = se_cent(SE);
% % 	
% % 	if (sum(c) > 0.1)
% % 		if (SE(round(pq(1) + c(1)),round(pq(2) + c(2))) == 1)
% % 			hm = scatter(c(1),c(2),'bd','filled');
% % 		else
% % 			hm = scatter(c(1),c(2),'bd');
% % 		end
% % 	end
% %
% %	set(hm,'LineWidth',2);
% 		
% 	%--
% 	% title display
% 	%--
% 	
% 	title_edit(['Structuring Element: ' inputname(1)]);
% 	xlabel_edit(['Support: [' num2str(pq(1)) ', ' num2str(pq(2)) '], Size: ' num2str(se_size(SE))]);
% 
% 	%--
% 	% set axis
% 	%--
% 	
% 	axis(g + 0.5*[-1 1 -1 1]);
% 	
% 	%--
% 	% image display of structuring element
% 	%--
% 	
% % 	fig;
% % 
% % 	se_view(SE);
% % 	
% % 	pq = se_supp(SE);
% % 	xlabel_edit(['Support: [' num2str(pq(1)) ', ' num2str(pq(2)) '], Size: ' num2str(se_size(SE))]);
% 	
% end
