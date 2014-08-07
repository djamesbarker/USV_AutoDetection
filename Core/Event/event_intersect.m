function [A, B1, B2] = event_intersect(E1, E2)

% event_intersect - compute intersection of events
% ------------------------------------------------
%
% A = event_intersect(E1)
%
%   = event_intersect(E1, E2)
%
% Input:
% ------
%  E1, E2 - event arrays to intersect
%
% Output:
% -------
%  A - intersection area

switch nargin
	
	%--
	% self intersection
	%--
	
	case 1
		pos = event_to_position(E1);

		A = sparse(rectint(pos, pos));
		
		N = pos(:, 3) .* pos(:, 4);
		
		N = repmat(N, 1, size(A, 2));
		
		B1 = A ./ N;
		
	%--
	% cross intersection
	%--
	
	case 2
		pos1 = event_to_position(E1); pos2 = event_to_position(E2);

		A = sparse(rectint(pos1, pos2));
		
		N = pos1(:, 3) .* pos1(:, 4); N = repmat(N, 1, size(A, 2));
		
		B1 = A ./ N;
		
		N = pos2(:, 3) .* pos2(:, 4); N = repmat(N, size(A, 1), 1);
		
		B2 = A ./ N;

end


%----------------------------------------------------------------------
% RECTINT
%----------------------------------------------------------------------

% NOTE: this is a modified copy of the MATLAB rectangle intersection

function out = rectint(PA, PB)

%  RECTINT Rectangle intersection area.
%
%  AREA = RECTINT(PA, PB) returns the area of intersection of the
%  rectangles specified by position vectors PA and PB.  
%
%  If PA and PB each specify one rectangle, the output AREA is a scalar.
%
%  PA and PB can also be matrices, where each row is a position vector.
%  AREA is then a matrix giving the intersection of all rectangles
%  specified by PA with all the rectangles specified by PB.  That is, if PA
%  is M-by-4 and PB is N-by-4, then AREA is an M-by-N matrix where
%  AREA(P,Q) is the intersection area of the rectangles specified by the
%  Pth row of PA and the Qth row of PB.
%
%  Note:  PA position vector is a four-element vector [X,Y,WIDTH,HEIGHT],
%  where the point defined by X and Y specifies one corner of the
%  rectangle, and WIDTH and HEIGHT define the size in units along the x-
%  and y-axes respectively.

%  Copyright 1984-2002 The MathWorks, Inc.
%  $Revision: 539 $  $Date: 2005-02-16 19:58:53 -0500 (Wed, 16 Feb 2005) $

%-----------------------------
% HANDLE INPUT
%-----------------------------

%--
% represent positions more effectively for operation
%--

A.count = size(PA, 1);

A.left = PA(:, 1); A.bottom = PA(:, 2); 

A.right = A.left + PA(:, 3); A.top = A.bottom + PA(:, 4);


% NOTE: we transpose the arrays here

B.count = size(PB, 1);

B.left = PB(:, 1)'; B.bottom = PB(:, 2)'; 

B.right = B.left + PB(:, 3)'; B.top = B.bottom + PB(:, 4)';

%--
% expand representations for comparison
%--

% NOTE: check that ones multiplication is not more efficient, observed elsewhere

A.left = repmat(A.left, 1, B.count);

A.bottom = repmat(A.bottom, 1, B.count);

A.right = repmat(A.right, 1, B.count);

A.top = repmat(A.top, 1, B.count);


B.left = repmat(B.left, A.count, 1);

B.bottom = repmat(B.bottom, A.count, 1);

B.right = repmat(B.right, A.count, 1);

B.top = repmat(B.top, A.count, 1);

%--
% intersection computation
%--

% NOTE: split computation further to get intersection rectangle as well as area

% hori = max(0, min(A.right, B.right) - max(A.left, B.left));

% vert = max(0, min(A.top, B.top) - max(A.bottom, B.bottom));

out = ...
	max(0, min(A.right, B.right) - max(A.left, B.left)) .* max(0, min(A.top, B.top) - max(A.bottom, B.bottom)) ...
;



