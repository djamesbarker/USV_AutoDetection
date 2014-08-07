function [out,h] = heap(mode,h,in,k)

% heap - heap functions
% ---------------------
%
% Function to create and operate on heaps.

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

%------------------------------------------------------------
% SWITCH ACCESS TO HEAP FUNCTIONS
%------------------------------------------------------------

switch (lower(mode))
	
	%--
	% create heap
	%--
	
	case ('create')
		
		if (nargin < 1)
			out = [];
		else
			out = heap_create(h);
		end
	
	%--
	% insert items into heap
	%--
	
	case ('insert')
		
		out = heap_insert(h,in);
		
	%--
	% remove top elements from heap
	%--
	
	case ('remove')
		
		if (nargin < 3)
			in = 1;
		end
		
		[out,h] = heap_remove(h,in);
		
	%--
	% replace top of heap with new element
	%--
	
	case ('replace')
		
		out = heap_replace(h,in);
		
	%--
	% change the value of a heap element
	%--
	
	case ('change')
		
		out = heap_change(h,in,k);
		
	%--
	% remove specific element from heap
	%--
	
	case ('delete')
		
		out = heap_delete(h,in);
				
	%--
	% join two heaps
	%--
	
	case ('join')
		
		
	%--
	% error
	%--
	
	otherwise
		
		disp(' ');
		disp(['Unavailable heap operation ''' mode '''.']);
		
end


%------------------------------------------------------------
% HEAP OPERATIONS
%------------------------------------------------------------


%-------------------------------------------
% HEAP_CREATE
%-------------------------------------------

function h = heap_create(in)

%--
% to start simply sort the array
%--

% note that we flip to get decreasing order

h = fliplr(sort(in));


%-------------------------------------------
% HEAP_INSERT
%-------------------------------------------

function h = heap_insert(h,in)

%--
% get length of heap and elements to append 
%--

n = length(h);

m = length(in);

%--
% consider empty heap input
%--

if (n == 0)
	h = in(1);
	n = 1;
	m = m - 1;
end

%--
% allocate resulting heap
%--

h = [h, zeros(1,m)];

%--
% append elements to heap
%--

for k = 1:m
		
	%--
	% append new element to heap and enforce heap condition
	%--
	
	h(n + k) = in(k);
	
	h = upheap(h,n + k);
	
end


%-------------------------------------------
% HEAP_REMOVE
%-------------------------------------------

function [out,h] = heap_remove(h,m)

%--
% enforce maximum elements to remove and flag for remove all
%--

n = length(h);

if (m >= n)
	m = n - 1;
	flag = 1;
else
	flag = 0;
end

%--
% remove elements from heap
%--

for k = 1:m

	%--
	% output top element, move last element of heap to top and shorten heap
	%--
	
	out(k) = h(1);
	
	h(1) = h(end);
	
	h = h(1:end - 1);
	
	%--
	% enforce heap condition
	%--
	
	h = downheap(h,1);
	
end

%--
% remove last element of heap
%--

if (flag)
	out(m + 1) = h(1);
	h = [];	
end


%-------------------------------------------
% HEAP_REPLACE
%-------------------------------------------

function h = heap_replace(h,in)


%-------------------------------------------
% HEAP_CHANGE
%-------------------------------------------

function h = heap_change(h,in)


%-------------------------------------------
% HEAP_DELETE
%-------------------------------------------

function h = heap_delete(h,in)


%-------------------------------------------
% HEAP_JOIN
%-------------------------------------------

function h = heap_join(h1,h2)


%------------------------------------------------------------
% LOW LEVEL HEAP OPERATIONS
%------------------------------------------------------------


%-------------------------------------------
% UPHEAP
%-------------------------------------------

function h = upheap(h,k)

%--
% keep value checked for swapping convenience
%--

val = h(k);

%--
% while selected vertex has value larger than its parent move up
%--

% use sentinel to check for (j == 0)

j = bitshift(k,-1);

while ((j > 0) & (h(j) < val))
	
	%--
	% swap with parent and update indices to check next parent
	%--
	
	h(k) = h(j);
	h(j) = val;

	k = j;
	j = bitshift(k,-1);
	
end


%-------------------------------------------
% DOWNHEAP
%-------------------------------------------

function h = downheap(h,k)

%--
% get length of heap
%--

n = length(h);

%--
% keep value checked for swapping convenience
%--

val = h(k);

%--
% while we can go down the heap and the children are larger move down
%--

k_max = bitshift(n,-1);

while (k <= k_max)
	
	%--
	% look at children and select largest
	%--
	
	j = bitshift(k,1);
	
	if (j < n)
		if (h(j) < h(j + 1))
			j = j + 1;
		end
	end
		
	%--
	% swap with child and update indices to check next children or end
	%--
	
	if (val < h(j))
		h(k) = h(j);
		h(j) = val;
		k = j;
	else
		return;
	end
	
end
