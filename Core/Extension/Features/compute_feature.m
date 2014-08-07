function F = compute_feature(X, ext, context)

% compute_feature - compute feature
% ---------------------------------
% 
% [F, info] = compute_feature(X, ext, context)
%
% Input:
% ------
%  X - signal 
%  ext - feature extension
%  context - context
%
% Output:
% -------
%  F - feature
%  info - coarse profile information

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

%------------------------------------------
% HANDLE INPUT
%------------------------------------------

%--
% set empty struct default context
%--

if (nargin < 3) || isempty(context)
	context = struct([]);
end

%------------------------------------------
% SETUP
%------------------------------------------
	
%--
% possibly time stamp
%--

if (nargout > 1)
	t0 = clock; 
end

%--
% handle float to double conversion if needed
%--

% NOTE: consider extension flag to indicate native float support

if isfloat(X)
	X = double(X);
end

%------------------------------------------
% COMPUTE FEATURE
%------------------------------------------

%--
% compute feature
%--
	
try
	Y = ext.fun.compute(X, ext.parameter, context);
catch
	Y = X; extension_warning(ext, 'Error in compute function.', lasterror);
end

%--
% get coarse profile information if needed
%--

% TODO: put this into a function

if (nargout > 1)
	
	info.ext = [ext.subtype, '::', ext.name];
	
	info.time = etime(clock, t0);

	info.form = fx;

	info.rate = numel(X) / (info.time * 10^6); 

end
