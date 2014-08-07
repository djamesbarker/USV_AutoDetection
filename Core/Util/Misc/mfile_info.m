function out = mfile_info(in,field)

% mfile_info - get file info for m-file
% -------------------------------------
%
%  info = mfile_info(file)
%
% value = mfile_info(file,field)
%
% Input:
% ------
%  file - file name
%  field - field to extract
%
% Output:
% -------
%  info - file info structure
%  value - info field value, empty if field does not exist

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
% $Revision: 1000 $
% $Date: 2005-05-03 19:36:26 -0400 (Tue, 03 May 2005) $
%--------------------------------

%--
% get file info
%--

out = dir(which(in));

%--
% extract field if needed
%--

if (nargin > 1)
	
	% NOTE: we return empty when the field is not available
	
	if (isfield(out,field))
		out = out.(field);
	else
		out = [];
	end
	
end
