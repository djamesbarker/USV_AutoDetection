function Z = mask_range(X,r)

% mask_range - double threshold mask
% ----------------------------------
% 
% Z = mask_range(X,r)
%
% Input:
% ------
%  X - input image
%  r - value range interval strings
%
% Output:
% -------
%  Z - range mask

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
% image or handle
%--

flag = 0;

if (ishandle(X))
    h = X;
    hi = get_image_handles(h);
    if (length(hi) == 1)
        X = get(hi,'cdata');
        flag = 1;
    else
        warning('Figure has more than one image. No computation performed.');
        return;
    end
    
end

%--
% put string in cell
%--

if (isstr(r))
	r = {r};
end

%--
% loop over interval strings
%--

Z = zeros(size(X));

for k = 1:length(r)
	
	%--
	% parse interval string
	%--
	
	[b,t] = parse_interval(r(k));
	
	%--
	% compute interval mask
	%--
	
	switch (t)
		
		case (0)
			Z = Z | ((X > b(1)) & (X < b(2)));
			
		case (1)
			Z = Z | ((X > b(1)) & (X <= b(2)));	
			
		case (2)
			Z = Z | ((X >= b(1)) & (X < b(2)));
			
		case (3)
			Z = Z | ((X >= b(1)) & (X <= b(2)));
			
	end

end

%--
% convert logical to uint8
%--

Z = uint8(Z);

%--
% update displayed image
%--

if (flag & ~nargout)
    figure(h);
    set(hi,'cdata',Z);
	set(gca,'clim',fast_min_max(Z));
end
		



	

