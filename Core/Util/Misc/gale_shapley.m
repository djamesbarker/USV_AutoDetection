function [P,M,W] = gale_shapley(varargin)

% gale_shapley - solve stable marriage matching problem
% -----------------------------------------------------
%
% [P,M,W] = gale_shapley(N)
%
%       P = gale_shapley(M,W)
%
% Input:
% ------
%  N - number of pairs
%  M - men preferences (N x N)
%  W - women preferences (N x N)
%
% Output:
% -------
%  P - stable pairing (N x 2)
%  M - men preferences (N x N)
%  W - women preferences (N x N)

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
% $Revision: 1.1 $
% $Date: 2004-05-12 11:13:33-04 $
%--------------------------------

%--
% handle input renaming and error checking
%--

switch (length(varargin))
	
	%--
	% number of pairs input
	%--
	
	case (1)
		
		%--
		% get number of pairs from input
		%--
		
		N = varargin{1};
		
		%--
		% create preferences
		%--
	
		M = preferences(N);
		W = preferences(N);
		
	%--
	% preferences input
	%--
	
	case (2)
		
		%--
		% get preferences from input
		%--
		
		M = varargin{1};
		W = varargin{2};
	
		%--
		% check size of preferences
		%--
		
		[m1,n1] = size(M);
		[m2,n2] = size(W);
		
		if ((m1 ~= n1) | (m2 ~= n2) | (m1 ~= m2))
			disp(' ');
			error('Improper size for preference matrices.');
		end
		
		%--
		% get number of pairs
		%--
		
		N = m1;

end

%--
% allocate pairing matrix
%--

P = zeros(N,2);
k = 0;

Q = zeros(N,1);

%--
% compute stable matching
%--

while (min(P(:,1)) == 0)
	
	%--
	% select man to propose
	%--
	
	ixm = min(setdiff(1:N,P(1:k,1))); % choose minimum index single man
	
	%--
	% select prefered woman to propose to
	%--
	
	Q(ixm) = Q(ixm) + 1; % update proposal counter

	ixw = find(M(ixm,:) == Q(ixm)); % select woman
		
	%--
	% propose
	%--
	
	ixp = find(P(:,2) == ixw); % pair index for woman
	
	if (isempty(ixp))
				
		%--
		% pair up man and woman, as woman is not paired
		%--
		
		k = k + 1;
		
		P(k,:) = [ixm,ixw];
		
	else
				
		%--
		% get woman preferences
		%--
		
		pc = W(ixw,P(ixp,1)); % preference for current man
		
		pm = W(ixw,ixm); % preference for proposing man
		
		%--
		% update man if proposing man is prepared
		%--
		
		if (pm < pc)
			P(ixp,1) = ixm;
		end
		
	end
	
end

%------------------------

function A = preferences(N)

% preferences - generate a matrix of preferences
% ----------------------------------------------
%
% A = preferences(N)
%
% Input:
% ------
%  N - number of elements to rank
%
% Output:
% -------
%  A - preference matrix

A = zeros(N);

for k = 1:N
	[ignore,A(k,:)] = sort(rand(1,N));
end
