function Y = linear_filter(X, F, n, b)

% linear_filter - linear filtering
% --------------------------------
%
% Y = linear_filter(X, F, n, b)
%
%   = linear_filter(X, F, Z, b)
%
% Input:
% ------
%  X - input image or handle to parent figure
%  F - linear filter
%  n - number of iterations (def: 1)
%  Z - computation mask image (def: [])
%  b - boundary behavior (def: -1)
%
% Output:
% -------
%  Y - linear filtered image

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
% $Date: 2006-08-29 14:04:35 -0400 (Tue, 29 Aug 2006) $
% $Revision: 6339 $
%--------------------------------

% TODO: extend mex to compute with multiple filters

% TODO: extend to handle filter decomposition at the mex level

%----------------------------------
% HANDLE INPUT
%----------------------------------

%--
% consider image or handle input
%--

% NOTE: this is very old code and has been put into a separate function

flag = 0;

if (length(X) == 1) && ishandle(X)
    
    h = X;
    
    hi = get_image_handles(h);
    
    if (length(hi) == 1)
        X = get(hi, 'cdata'); flag = 1;
    else
        warning('Figure has more than one image. No computation performed.');
        return;
    end
    
end

%--
% set boundary behavior
%--

% NOTE: the boundary behavior code is documented in 'image_pad'

if (nargin < 4)
    b = -1;
end

%--
% iteration or mask
%--

if (nargin < 3) || isempty(n)
    
    %--
    % set default behavior of single unmasked iteration
    %--
    
    n = 1; Z = [];
    
else
    
    %--
    % check whether input may be computation mask rather than iterations
    %--
    
    Z = [];
    
    [r, c, s] = size(X);
    
    if (all(size(n) == [r, c]))
        Z = n; n = 1;
    end
    
end

%---------------------------------------
% MULTIPLE PLANE IMAGES
%---------------------------------------

if (ndims(X) > 2)
    
    [r, c, s] = size(X);
    
    for k = 1:s
        
        if isempty(Z)
            Y(:, :, k) = linear_filter(X(:, :, k), F, n, b);
        else
            Y(:, :, k) = linear_filter(X(:, :, k), F, Z, b);
        end
        
    end
    
    
    %---------------------------------------
    % SCALAR IMAGES
    %---------------------------------------
    
else
    
    %--
    % iterate operator
    %--
    
    if isempty(Z)
        
        %--
        % simple filter computation
        %--
        
        if isreal(F)
            
            % Get size of raw filter data
            
            Fraw = F;
            
            pq = (size(Fraw) - 1)./2;
            
            % Invoke Overlap Add Method 2D convolution if it will be faster
            
            if isempty(Z) && numel(X) >= 32768 && numel(Fraw) >= 4300
                
                X = image_pad(X, pq, b);
                
                Y = olam_conv2(X, rot90(Fraw,2), 'valid'); return;
            end
            
            % Invoke MATLAB conv2
            
            
            X = image_pad(X, pq, b);
            
            Y = conv2(double(X), double(rot90(Fraw,2)), 'valid'); return;
            
        %--
        % decomposed filter computation
        %--
            
        else
            
            for j = 1:n
                Y = linear_filter_decomp(X, F, b);
                if (n > 1)
                    X = Y;
                end
            end
            
        end
        
        %--
        % mask operator
        %--
        
    else
        
        % NOTE: the decomposed filter is not used on masked computation
        
        if ~isreal(F)
            F = F.H;
        end
        
        pq = (size(F) - 1)./2;
        
        X = image_pad(X, pq, b);
        Z = image_pad(Z, pq, 0);
        Y = linear_filter_(X, F, uint8(Z));
        
    end
    
end

%---------------------------------------
% DISPLAY OUTPUT
%---------------------------------------

% NOTE: this was part of the old image processing framework

% NOTE: this framework permits the processing of generic figure displayed images

if flag && view_output
    
    switch view_output
        
        %--
        % update display of image from figure
        %--
        
        case 1
            figure(h);
            set(hi, 'cdata', Y);
            set(gca, 'clim', fast_min_max(Y));
            
            %--
            % produce a new image display
            %--
            
        otherwise
            fig; image_view(Y);
            
    end
    
end


%-----------------------------------------------
% LINEAR_FILTER_DECOMP
%-----------------------------------------------

function Y = linear_filter_decomp(X, F, b)

% linear_filter_decomp - apply decomposed linear filter
% -----------------------------------------------------
%
% Y = linear_filter_decomp(X, F, b)
%
% Input:
% ------
%  X - input image
%  F - decomposed filter
%  b - boundary behavior

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Date: 2006-08-29 14:04:35 -0400 (Tue, 29 Aug 2006) $
% $Revision: 6339 $
%--------------------------------

% TODO: consider whether the approximation needs to be renormalized

%--
% pad input image once
%--

pq = (size(F.H) - 1)./2;

X = image_pad(X, pq, b);

%--
% apply first component
%--

fx = F.X(:, 1)'; fy = F.S(1) * F.Y(:, 1);

Y = linear_filter_(linear_filter_(X, fx), fy);

%--
% apply remaining components if needed
%--

% NOTE: the rank is computed using the tolerance parameter

for k = 2:F.rank
    
    fx = F.X(:, k)'; fy = F.S(k) * F.Y(:, k);
    
    Y = Y + linear_filter_(linear_filter_(X, fx), fy);
    
end
