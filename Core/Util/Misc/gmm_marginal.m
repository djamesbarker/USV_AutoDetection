function out = gmm_marginal(in,d)

% gmm_marginal - create marginal mixture model
% --------------------------------------------
%
% out = gmm_marginal(in,d)
%
% Input:
% ------
%  in - input mixture density model
%  d - marginal dimensions
%
% Output:
% -------
%  out - marginal mixture density model

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
% check marginal dimensions
%--

if (round(d) ~= d)
	disp(' ');
	error('Marginal dimensions must be integer values.');
end

if (any(d > in.nin) | any(d < 1))
	disp(' ');
	error('Desired marginal dimensions are out of bounds.');
end

if (~isequal(d,unique(d)))
	disp(' ');
	error('Marginal dimensions must be unique and ordered.');
end

nin = length(d);

%---------------------------------------------
% CREATE MARGINAL MODEL
%---------------------------------------------

%--
% create marginal mixture model
%--

out = gmm(nin,in.ncentres,in.covar_type);

%--
% update centres and covariance
%--

out.centres = in.centres(:,d);

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
		
		out.covars = in.covars(:,d);

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
			tk = tk(:,d); 
			tk = tk(d,:);
			
			out.covars(:,:,k) = tk;
			
		end
				
	case ('ppca')

	otherwise

end
