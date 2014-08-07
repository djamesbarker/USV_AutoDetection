function out = range_intersect(varargin)

% range_intersect - intersect ranges
% ----------------------------------
%
% out = range_intersect(in)
%
%       = range_intersect(in_1,...,in_n)
%
% Input:
% ------
%  in - range strucure array
%  in_k - range structure
%
% Output:
% -------
%  out - intersection range or range array

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

%---------------------------------------
% HANDLE INPUT
%---------------------------------------

n = length(varargin);

%--
% pack variable arguments
%--

if (n > 1)
	
	for k = 1:n
		in(k) = varargin{k};
	end
	
else

	% NOTE: we are assuming input is range structure array
	
	if (length(varargin{1}) > 1)
		in = varargin{1};
	else
		out = in;
		return;
	end

end

%---------------------------------------
% COMPUTE INTERSECTION
%---------------------------------------

%--
% get range types (available types are 'colon','interval','ray','strings')
%--

type = struct_field(in,'type');

unique_type = unique(type);

%--
% error when trying to intersect strings with other things
%--

if ((length(unique_type) > 2) && ~isempty(find(strcmp('strings',unique_type))))
	disp(' '); 
	error('String set ranges cannot be intersected with other ranges.');
end

%--
% single type intersections are straightforward
%--

if (length(unique_type) == 1)

	% NOTE: use pairwise intersections at this level
	
	switch (unique_type{1})

		case ('colon')
			out = colon_intersect(in);

		case ('interval')
			out = interval_intersect(in);

		case ('ray') 
			out = ray_intersect(in); 

		case ('strings')
			out = strings_intersect(in);

	end
	
%--
% perform mixed range type intersection
%--

else
	
	%--
	% sort ranges by type
	%--
	
	[ignore,ix] = sort(type); in = in(ix);
	
	%--
	% perform intersection
	%--
	
	% NOTE: which ranges should be first considered ?
	
	for k = 1:n
	
	end
	
end


%---------------------------------------
% COLON_INTERSECT
%---------------------------------------

function out = colon_intersect(in1,in2)

%--
% get colon data
%--

d1 = in1.data; 
d2 = in2.data; 

%--
% perform intersection
%--


%---------------------------------------
% INTERVAL_INTERSECT
%---------------------------------------

function out = interval_intersect(in1,in2)

%--
% get interval data
%--

d1 = in1.data; 
d2 = in2.data; 

%--
% perform intersection
%--


%---------------------------------------
% RAY_INTERSECT
%---------------------------------------

function out = ray_intersect(in1,in2)

%--
% get ray data
%--

d1 = in1.data; 
d2 = in2.data; 

%--
% perform intersection
%--


%---------------------------------------
% STRINGS_INTERSECT
%---------------------------------------

function out = strings_intersect(in1,in2)

%--
% get strings data
%--

d1 = in1.data; 
d2 = in2.data; 

%--
% perform intersection
%--


