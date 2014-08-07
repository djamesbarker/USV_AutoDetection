function h = field_view(F,Z,opt)

% field_view - vector display of complex field image
% --------------------------------------------------
%
% h = field_view(F,Z,opt)
%
% X = field_view(F,Z,opt)
%
% Input:
% ------
%  F - complex field image
%  Z - mask image (def: [])
%  opt - display options
%
% Output:
% -------
%  h - vector display handles
%  X - data required to display field

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
% $Date: 2003-10-08 22:51:16-04 $
% $Revision: 1.2 $
%--------------------------------

%--------------------------------------------
% HANDLE INPUT
%--------------------------------------------

%--
% set default options
%--

if ((nargin < 3) || isempty(opt))
	opt = field_options;
end

%--
% output default options
%--

if (nargin < 1)
	h = opt;
	return;
end

%--------------------------------------------
% MASK USING AMPLITUDE
%--------------------------------------------

% field is always masked for clarity and efficiency

if ((nargin < 2) || isempty(Z))
	
	%--
	% compute field amplitude
	%--
	
	N = abs(F);
	
	%--
	% compute mask based on threshold
	%--
	
	% a negative threshold is used to represent an amplitude value
	% threshold. a positive value is used in the computation of an
	% automatic order statictic threshold
	
	if (opt.threshold > 0)
		
		%--
		% order statistic threshold
		%--
	
		v = fast_rank(N,opt.threshold);
		Z = (N > v);
		
	else
		
		%--
		% amplitude threshold
		%--
		
		Z = (N > abs(v));
		
	end
			
end

%--------------------------------------------
% CREATE VECTOR FIELD IMAGE DISPLAY
%--------------------------------------------

%--
% compute display grid
%--

[m,n] = size(F);

X = repmat(1:n,m,1);
Y = repmat((1:m)',1,n);
		
%--
% apply mask selection of data (data is put into row format)
%--

if (isempty(Z))

	%--
	% no selection
	%--
	
	x = X(:)';
	y = Y(:)';
	f = F(:).'; % note non-conjugate transpose
	
else

	%--
	% mask selection
	%--
	
	ix = find(Z);
	
	x = X(ix)';
	y = Y(ix)';
	f = F(ix).'; % note non-conjugate transpose
	
end

%--
% compute and display normal field vectors
%--

h = [];

if (opt.normal.on)
	
	%--------------------------------------------
	% NORMAL VECTORS
	%--------------------------------------------

	%--
	% compute normal field vectors
	%--
	
	if (isempty(opt.normal.amplify) || (opt.normal.amplify == 1))
		
		%--
		% no amplification
		%--
		
		tx = x + real(f);
		ty = y + imag(f);
		
	else
		
		%--
		% amplify normal vectors
		%--
		
		a = opt.normal.amplify;
		
		tx = x + (a * real(f));
		ty = y + (a * imag(f));
		
	end
	
	%--
	% use nans break the display of a single line
	%--
	
	na = repmat(NaN,size(tx));
	
	uu = [x; tx; na];
	vv = [y; ty; na];
	
	%--
	% display normal field vectors or output required data to produce plot
	%--
	
	if (opt.plot)
		
		%--
		% plot normal field
		%--
		
		tmp = plot( ...
			uu(:), ...
			vv(:), ...
			'color', opt.normal.color, ...
			'linewidth', opt.normal.linewidth ...
		);
	
		h = [h, tmp];
		
	else
		
		%--
		% output data to produce normal plot
		%--
		
		h.normal.xdata = uu(:);
		h.normal.ydata = vv(:);
		
	end
	
	%--------------------------------------------
	% NORMAL VECTOR ARROWHEADS
	%--------------------------------------------
	
	if (opt.arrow.on)

		%--
		% compute arrowhead vectors
		%--
		
		a = opt.arrow.length;
		b = opt.arrow.width;
		
		af = a*f;
		d = b*i*(f - af); % rotated difference
		
		t1 = af + d; % initial point
		t2 = af - d; % final point
			
		hu = [tx - real(t1); tx; tx - real(t2); na];
		hv = [ty - imag(t1); ty; ty - imag(t2); na];
		
		%--
		% plot arrowheads or output required data to reproduce plot
		%--
		
		if (opt.plot)
			
			%--
			% plot arrowheads
			%--
			
			hold on;
		
			tmp = plot( ...
				hu(:), ...
				hv(:), ...
				'color', opt.normal.color, ...
				'linewidth', opt.normal.linewidth ...
			);
		
			h = [h, tmp];
			
		else
			
			%--
			% output data to produce arrowhead plot
			%--
			
			h.arrow.xdata = hu(:);
			h.arrow.ydata = hv(:);
			
		end	
	
	end
	
	%--
	% display normal vector base markers
	%--
	
	% this code is not often used
	
	if (opt.marker.on)
	
		hold on;
		
		if (opt.marker.filled)
			scatter(x,y,opt.marker.size,opt.marker.color,opt.marker.type,'filled');
		else
			scatter(x,y,opt.marker.size,opt.marker.color,opt.marker.type);
		end
		
	end
	
end

%--
% compute and display tangent field vectors
%--

if (opt.tangent.on)
	
	%--
	% compute and display normal vector
	%--
	
	% compute second point in vector
	
	tx = x + imag(f);
	ty = y - real(f);
	
	% update first point in vector
	
	x = x - imag(f);
	y = y + real(f);
	
	na = repmat(NaN,size(tx));
	
	uu = [x; tx; na];
	vv = [y; ty; na];
	
	%--
	% plot tangent field or output data required to reproduce plot
	%--
	
	if (opt.plot)
		
		%--
		% plot tangent field
		%--
		
		tmp = plot( ...
			uu(:), ...
			vv(:), ...
			'color', opt.tangent.color, ...
			'linewidth', opt.tangent.linewidth ...
		);
	
		h = [h, tmp];
		
	else
		
		%--
		% output required data to reproduce plot
		%--
		
		h.tangent.xdata = uu(:);
		h.tangent.ydata = vv(:);
		
	end
	
end

%--
% attach display options to data for field display reproduction
%--

if (~opt.plot)
	
	h.opt = opt;

end

%------------------------------------------
% SUBFUNCTIONS
%------------------------------------------

%--
% field_options
%--

function opt = field_options

% field_options - create vector field display options
% ---------------------------------------------------
%
% opt = field_options
%
% Output:
% -------
%  opt - vector field display options

%------------------------------------------
% plot option
%------------------------------------------

opt.plot = 1;

%------------------------------------------
% normal field options	
%------------------------------------------

opt.normal.on = 1;

opt.normal.amplify = 1;

opt.normal.color = color_to_rgb('Bright Red'); 

opt.normal.linewidth = 1;

%------------------------------------------
% tangent field options
%------------------------------------------

opt.tangent.on = 1; 

opt.tangent.amplify = 1;

opt.tangent.color = color_to_rgb('Cyan');

opt.tangent.linewidth = 1;

%------------------------------------------
% arrow options
%------------------------------------------

opt.arrow.on = 1;

opt.arrow.color = [1,1,1];

opt.arrow.linewidth = 1;

opt.arrow.length = 0.3;

opt.arrow.width = 0.3;

%------------------------------------------
% marker options
%------------------------------------------

opt.marker.on = 0;

opt.marker.color = [1,1,1];

opt.marker.size = 9;

opt.marker.type = 'o';

opt.marker.filled = 0;

%------------------------------------------
% masking options
%------------------------------------------

% a negative threshold is used to represent an amplitude value
% threshold. a positive value is used in the computation of an
% automatic order statictic threshold
	
opt.threshold = 0.5;


