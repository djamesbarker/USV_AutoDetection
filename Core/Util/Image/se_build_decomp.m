function SEQ = se_build_decomp(SE,D)

% se_build_decomp - build structuring element decomposition
% ---------------------------------------------------------
%
% SEQ = se_build_decomp(SE,D);
%
% Input:
% ------
%  SE - structuring element to decompose
%  D - dictionary integers
%
% Output:
% -------
%  SEQ - structuring element decomposition

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
% set dictionary
%--

if ((nargin < 2) | isempty(D))
	D = [17, 24, 26, 50, 58, 80, 144, 154, 156, 176, 178, 184, 186];
end

%--
% create structuring element library
%--

B = zeros(3,3,length(D));

for k = 1:length(D)
	
	b = fliplr(double(dec2bin(D(k))) - 48);
	b = [b, zeros(1,9 - length(b))];
	
	B(:,:,k) = reshape(b,3,3);
	
end

B

%--
% get size of input structuring element
%--

A = size(SE);

N = se_size(SE);

%--
% search through compositions
%--


SEQ = SE;

for j = 1:length(D)
	
	j
	
	B1 = B(:,:,j);
	
	for k = 1:length(D)
		
		B2 = B(:,:,k);
		
		B12 = se_comp(B1,B2);
		
		if (any(size(B12) > A) | (se_size(B12) > N))
			
			continue;
			
		else
			
			if (isempty(se_diff(SE,B12)))
				
				SEQ = {B1,B2};
				
			else
				
				for l = 1:length(D)
					
					B3 = B(:,:,l);
					
					B123 = se_comp(B12,B3);
					
					
					fig; se_view(B123); pause(0.1); close;
					
					
					if (any(size(B123) > A) | (se_size(B123) > N))
		
						continue;
						
					else
						
						if (isempty(se_diff(SE,B12)))
							
							SEQ = {B1,B2,B3};
							
						else
							
							continue;
							
						end
						
					end
					
				end
				
			end
			
		end
		
	end 
	
end

