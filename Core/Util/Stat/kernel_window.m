function k = kernel_window(type,n)

% kernel_window - create smoothing kernel window
% ----------------------------------------------
% 
% k = kernel_window(type,n)
%
% Input:
% ------
%  type - kernel type
%  n - kernel length
%
% Output:
% -------
%  k - smoothing kernel window

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
% $Revision: 132 $
% $Date: 2004-12-02 15:58:47 -0500 (Thu, 02 Dec 2004) $
%--------------------------------

%--------------------------------------------
% HANDLE INPUT
%--------------------------------------------

%--
% ensure odd length kernel
%--

if (~mod(n,2))
	n = n - 1;
end

%--------------------------------------------
% COMPUTE KERNEL ACCORDING TO TYPE
%--------------------------------------------

% NOTE: we capitalize the kernel type

switch (title_caps(type))
	
	%--
	% binomial kernel
	%--
	
	case ('Binomial')
		
		k = filt_binomial(1,n);
	
	%--
	% gaussian kernel
	%--
	
	case ('Gauss')
		
		k = linspace(-4,4,n);
		k = exp(-k.^2);
		k = k / sum(k);
	
	%--
	% epanechnikov kernel
	%--
	
	case ('Epanechnikov')
		
		k = linspace(-1,1,n);
		k = (1 - k.^2);
		k = k / sum(k);
	
	%--
	% tukey biweight kernel
	%--
	
	case ('Tukey')
		
		k = linspace(-1,1,n);
		k = (1 - k.^2).^2;
		k = k / sum(k);
	
	%--
	% uniform kernel
	%--
	
	case ('Uniform')
		
		k = ones(1,n) / n;
		
	%--
	% unrecognized kernel type
	%--
	
	otherwise
		
		disp(' ');
		error(['Unrecognized kernel type ''' type '''.']);
	
end
