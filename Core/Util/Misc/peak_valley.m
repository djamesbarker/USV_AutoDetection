function [peak,valley] = peak_valley(seq)

% peak_valley - compute peaks and valleys of sequence
% ---------------------------------------------------
%
% [peak,valley] = peak_valley(seq)
%
% Input:
% ------
%  seq - input sequence
%
% Output:
% -------
%  peak - peak array
%  valley - valley array

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
% $Revision: 1.3 $
% $Date: 2003-09-16 01:26:31-04 $
%--------------------------------

% there exist more concise representations which store the output information implicitly

%-------------------------------------
% TEST CODE
%-------------------------------------

if (~nargin)
	
	%--
	% compute peaks and valleys of some random sample sequences
	%--
	
	for k = 1:10
		
		% generate random sequence
		
		x = smooth(cumsum(randn(1,100)),9);
		
		% no output arguments produce the disagostic plot
		
		peak_valley(x);
		
	end
	
	return;
	
end

%-------------------------------------
% FIND PEAKS AND VALLEYS
%-------------------------------------

%--
% check input and put vector in column form
%--

if (min(size(seq)) == 1)
	seq = seq(:);
else
	error('Input must be a vector.');
end

%--
% get length of sequence
%--

n = length(seq);

%--
% get interior peak indices and values
%--

pix = find((seq(2:(n - 1)) > seq(1:(n - 2))) & (seq(2:(n - 1)) > seq(3:n))) + 1;

if (~isempty(pix))
	pv = seq(pix);
else
	pv = [];
end

%--
% get interior valley indices and values 
%--

vix = find((seq(2:(n - 1)) < seq(1:(n - 2))) & (seq(2:(n - 1)) < seq(3:n))) + 1;

if (~isempty(vix))
	vv = seq(vix);
else 
	vv = [];
end
	
%--
% evaluate extremes at start and end of sequence
%--

if (seq(1) < seq(2))
	
	vix = [1; vix];
	vv = [seq(1); vv];
	
elseif (seq(1) > seq(2))
	
	pix = [1; pix];
	pv = [seq(1); pv];
	
end
	
if (seq(end) < seq(end - 1))
	
	vix = [vix; n];
	vv = [vv; seq(n)];
	
elseif (seq(end) > seq(end - 1))
	
	pix = [pix; n];
	pv = [pv; seq(n)];
	
end
	
%--
% compute peak widths and depths
%--

for k = 1:length(pix)
	
	%--
	% compute left
	%--
	
	tmp = find(vix < pix(k));
	
	if (~isempty(tmp))
		
		tmp = vix(max(tmp));
		
		plw(k) = tmp - pix(k);
		pld(k) = seq(tmp) - pv(k);
		
	else
		
		if (pix(k) == 1)
			plw(k) = 0;
			pld(k) = 0;
		else
			plw(k) = nan;
			pld(k) = nan;
		end
		
	end
	
	%--
	% compute right
	%--
	
	tmp = find(vix > pix(k));
	
	if (~isempty(tmp))
		
		tmp = vix(min(tmp));
		
		prw(k) = tmp - pix(k);
		prd(k) = seq(tmp) - pv(k);
		
	else
		
		if (pix(k) == n)
			prw(k) = 0;
			prd(k) = 0;
		else
			prw(k) = nan;
			prd(k) = nan;
		end
		
	end
	
end

%--
% pack peak results structure array
%--

% width and depth of an extremum can be used in many applications

if (length(pix))
	
	for k = 1:length(pix)
		
		peak(k).type = 'peak';
		
		peak(k).ix = pix(k);
		
		peak(k).value = pv(k);
		
		peak(k).width = [plw(k), prw(k)];
		
		peak(k).depth = [pld(k), prd(k)];
		
	end
	
else
	
	peak = [];
	
end

%--
% compute valley widths and depths if needed
%--

if (nargin == 1)

	%--
	% compute valley widths and depths
	%--

	for k = 1:length(vix)
		
		%--
		% compute left
		%--
		
		tmp = find(pix < vix(k));
		
		if (~isempty(tmp))
			
			tmp = pix(max(tmp));
			
			vlw(k) = tmp - vix(k);
			vld(k) = seq(tmp) - vv(k);
			
		else
			
			if (vix(k) == 1)
				vlw(k) = 0;
				vld(k) = 0;
			else
				vlw(k) = nan;
				vld(k) = nan;
			end
			
		end
		
		%--
		% compute right
		%--
		
		tmp = find(pix > vix(k));
		
		if (~isempty(tmp))
			
			tmp = pix(min(tmp));
			
			vrw(k) = tmp - vix(k);
			vrd(k) = seq(tmp) - vv(k);
			
		else
			
			if (vix(k) == n)
				vrw(k) = 0;
				vrd(k) = 0;
			else
				vrw(k) = nan;
				vrd(k) = nan;
			end
			
		end
		
	end

	%--
	% pack valley results structure array
	%--
	
	% width and depth of an extremum can be used in many applications
	
	if (length(vix))
		
		for k = 1:length(vix)
			
			valley(k).type = 'valley';
			
			valley(k).ix = vix(k);
			
			valley(k).value = vv(k);
			
			valley(k).width = [vlw(k), vrw(k)];
			
			valley(k).depth = [vld(k), vrd(k)];
			
		end
	
	else
		
		valley = [];
	
	end
	
end

%-------------------------------------
% DISPLAY CODE (USED IN TEST CODE)
%-------------------------------------

%--
% produce diagnostic plot
%--

if (~nargout)
	
	fig; 
	
	%--
	% plot sequence
	%--
	
	plot(seq,'b-');
	
	hold on;
	
	%--
	% plot peaks and valleys
	%--
	
	plot(pix,pv,'go');
	
	plot(vix,vv,'ro');
	
	%--
	% display the widths
	%--
	
	for k = 1:length(pix)
		plot([pix(k) + plw(k), pix(k) + prw(k)],[pv(k), pv(k)],'g:');
	end
	
	for k = 1:length(vix)
		plot([vix(k) + vlw(k), vix(k) + vrw(k)],[vv(k), vv(k)],'r:');
	end
	
	%--
	% display the depths
	%--
	
	f = 0.99;
	
	for k = 1:length(pix)
		plot((pix(k) + f*plw(k))*ones(1,2),[pv(k), pv(k) + pld(k)],'g:');
		plot((pix(k) + f*prw(k))*ones(1,2),[pv(k), pv(k) + prd(k)],'g:');
	end
	
	for k = 1:length(vix)
		plot((vix(k) + f*vlw(k))*ones(1,2),[vv(k), vv(k) + vld(k)],'r:');
		plot((vix(k) + f*vrw(k))*ones(1,2),[vv(k), vv(k) + vrd(k)],'r:');
	end
	
end
