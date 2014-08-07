function out = gmm_permute(in,p)

% gmm_permute - permute mixture model inputs
% ------------------------------------------
%
% out = gmm_permute(in,p)
%
% Input:
% ------
%  in - input mixture density model
%  p - dimension index permutation
%
% Output:
% -------
%  out - permuted mixture density model

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

%---------------------------------------------
% HANDLE INPUT
%---------------------------------------------

%--
% check permutation
%--

if (round(p) ~= p)
	disp(' ');
	error('Permutation dimension indices must be integer values.');
end

if (~isequal(1:in.nin,sort(p)))
	disp(' ');
	error('Input vector is not dimension index permutation.');
end

%---------------------------------------------
% CREATE MARGINAL MODEL
%---------------------------------------------

%--
% update input to be output
%--

out = in;

%--
% update centres and covariance
%--

out.centres = in.centres(:,p);

switch (in.covar_type)

	%--
	% spherical covariance
	%--

	case ('sperical')

		% NOTE: no dimension specific covariance implies no changes
		
	%--
	% diagonal covariance
	%--

	case ('diagonal')
		
		out.covars = in.covars(:,p);

	%--
	% full covariance
	%--

	case ('full')

		%--
		% create temporary covariance structure
		%--
		
		% NOTE: select covariance rows and columns
		
		for k = 1:out.ncentres
			
			tk = in.covars(:,:,k); 
			tk = tk(:,p); 
			tk = tk(p,:);
			
			out.covars(:,:,k) = tk;
			
		end
				
	case ('ppca')

	otherwise

end
