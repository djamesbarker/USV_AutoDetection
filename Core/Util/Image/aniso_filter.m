function Y = aniso_filter(X,type,scale,it)

% aniso_filter - anisotropic diffusion filter
% -------------------------------------------
%
% Y = aniso_filter(X,type,scale,it)
%
% Input:
% ------
%  X - input image
%  type - type of diffusion (def: 'tukey')
%  scale - gradient scale (def: 20)
%  it - number of iterations (def: 50)
%
% Output:
% -------
%  Y - filtered image

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
% $Date: 2003-06-11 18:22:03-04 $
%--------------------------------

% TODO: provide a common scale parameter for the various types of diffusion

%---------------------------
% HANDLE INPUT
%---------------------------

%--
% set default number of iterations
%--

if ((nargin < 4) || isempty(it))
	it = 50;
end

% check number of iterations

if ((it ~= round(it)) || (it < 1))
	disp(' '); 
	error('Number of iterations must be a positive integer.');
end

%--
% set gradient scale
%--

% TODO: implement a smart default setting for the scale

if ((nargin < 3) || isempty(scale))
	scale = 20;
end

% check scale

if (scale < 0)
	disp(' ');
	warning('Negative scale values can lead to unstable diffusion.'); 
end 

%--
% set diffusion type
%--

if ((nargin < 2) || isempty(type))
	type = 'tukey';
end
	
%--
% convert string type to code
%--

switch (lower(type))
	
	case ('linear')
		code = 0;
		
	case ('lorentz')
		code = 1;
		
	case ('tukey')
		code = 2;
		
	case ('huber')
		code = 3;
		
	otherwise
		disp(' ');
		error(['Unrecognized diffusion type ''' type '''.']);
		
end

%--
% map input to double
%--

X = double(X);

%--
% handle multiple plane images
%--

if (ndims(X) == 3)
	
	for k = 1:3
		Y(:,:,k) = aniso_filter_(X(:,:,k),code,scale,0.25,it);
	end
	
	return;
	
end

%---------------------------
% COMPUTE USING MEX
%---------------------------

% NOTE: the integration step size is not exposed

% NOTE: scale is ignored in the mex computation of linear diffusion

Y = aniso_filter_(X,code,scale,0.25,it);
