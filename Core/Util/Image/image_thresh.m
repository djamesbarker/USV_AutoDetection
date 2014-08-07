function Y = image_thresh(X,T)

% image_thresh - image thresholding
% ---------------------------------
%
% Y = image_thresh(X,T)
%
% Input:
% ------
%  X - input image
%  T - single or multiple increasing thresholds
%
% Output:
% -------
%  M - thresholded or multiply thresholed image

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
% $Date: 2005-01-26 15:11:52 -0500 (Wed, 26 Jan 2005) $
% $Revision: 468 $
%--------------------------------

% NOTE: the results of this computation is related to quantization

%--
% check threshold input
%--

if ((length(T) > 1) && any(diff(T) <= 0))
	disp(' ');
	error('Thresholds must be increasing.');
end

%--
% convert input to double if needed
%--

% TODO: mex should handle a variety of types

if (~strcmp(class(X),'double'))
	X = double(X);
end

%--
% use mex for thresholding
%--

Y = image_thresh_(X,T);
