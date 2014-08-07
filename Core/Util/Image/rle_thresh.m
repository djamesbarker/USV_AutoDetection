function [t,ct,H] = rle_thresh(X,ct)

% rle_thresh - compute threshold based on run-length feature
% ----------------------------------------------------------
% 
% [t,ct,H] = rle_thresh(X,ct)
%
% Input:
% ------
%  X - input image
%  ct - candidate thresholds (def: 32 uniform values in range)
%
% Output:
% -------
%  t - selected threshold
%  ct - candidate thresholds
%  H - run-length histograms for candidate thresholds

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
% $Date: 2004-12-02 15:58:47 -0500 (Thu, 02 Dec 2004) $
% $Revision: 132 $
%--------------------------------
	
%--
% set and check candidate thresholds
%--

b = fast_min_max(X);

if (nargin < 2)
	
	%--
	% compute linearly spaced vector in range and remove extremes
	%--
	
	nt = 16;
	
	ct = linspace(b(1),b(2),nt + 2);
	
	ct(1) = [];
	ct(end) = [];
		
else

	%--
	% remove candidate thresholds out of range
	%--

	ct(ct < b(1)) = [];

	if (isempty(ct))
		t = [];
		return;
	end

	ct(ct > b(2)) = [];

	if (isempty(ct))
		t = [];
		return;
	end

	if (length(ct) == 1)
		t = ct;
		return;
	end
	
	nt = length(ct);
	
end

%--
% apply candidate thresholds
%--

% NOTE: results of multiple thresholds is packed into single image

Y = image_thresh(X,ct);

%--
% compute run-length codes and statistics
%--

% NOTE: the Y image contains the number of candidate thresholds exceeded

r = 20; 

H = zeros(nt,r);

for k = 1:nt
	
	H(k,:) = rle_hist(Y,r,[],k - 0.5);
	
	fig; 
	
	subplot(2,1,1); 
	imagesc(Y < (k - 0.5));
	title(['X > T = ' num2str(ct(k))]);
	
	subplot(2,2,3); 
	plot(H(k,:),'ro-');
	title('Run-length Dist.');
	
	subplot(2,2,4); 
	[h,c] = hist_1d(X,32,[],(Y > (k - 0.5)));
	plot(c,h,'go-');
	title('Value Dist.');
	
	colormap(gray);
	
end

% fig; 
% plot(H(:,1),'bo-');
% xlabel('T');
% ylabel('#(1-Runs)');

fig; plot(ct,H,'o-');

fig; plot(-diff(H,2,1),'o-');


t = [];
