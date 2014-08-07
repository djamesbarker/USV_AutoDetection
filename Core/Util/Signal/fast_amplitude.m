function [A, M] = fast_amplitude(X, window, overlap, mode)

%--
% handle input
%--

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

if nargin < 4
	mode = 'abs';
end

if nargin < 3 || isempty(overlap)
	overlap = 0;
end

if nargin < 2 || isempty(window)
	window = ones(1, 100);
end

if isscalar(window)
	window = ones(1, window);
end

%--
% compute amplitude
%--

nch = size(X, 2); 

switch mode
	
	case 'rms'
	
		% NOTE: square signal to compute RMS, this should happen in-place
		
		X = X.^2;
		
		A = cell(1, nch); M = cell(1, nch);
		
		for k = 1:nch		
			[A{k}, M{k}] = fast_amplitude_mex(X(:, k), window, overlap);
		end
		
		% NOTE: in this case only one column from each cell is informative
		
		for k = 1:nch
			A{k} = A{k}(:, 2); M{k} = M{k}(:, 2);
		end
		
		A = sqrt([A{:}]); M = sqrt([M{:}]);
	
	case 'abs'

		for k = 1:nch	
			[A(:,:,k), M(:,:,k)] = fast_amplitude_mex(X(:, k), window, overlap);	
		end

	otherwise

		error('Unrecognized mode.')

end

