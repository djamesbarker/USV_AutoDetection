function format = format_create(varargin)

% forrmat_create - create format structure
% -------------------------------------
%
%  format = format_create
%
% Output:
% -------
%  format - format structure

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
% $Revision: 563 $
% $Date: 2005-02-21 05:59:20 -0500 (Mon, 21 Feb 2005) $
%--------------------------------

%---------------------------------------------------------------------
% CREATE FORMAT STRUCTURE
%---------------------------------------------------------------------

persistent FORMAT_PERSISTENT;

if (isempty(FORMAT_PERSISTENT))
	
	%--------------------------------
	% PRIMITIVE FIELDS
	%--------------------------------
	
	format.name = [];		% human readable name of format (equivalent to description for 'imformats')
	
	format.ext = cell(0);	% extensions associated with format

	% NOTE: it is not clear that this belongs here
	
	format.home = [];		% home page for format handler
	
% 	format.version = [];	% version of format handler
	
	%--------------------------------
	% FILE ACCESS AND CREATION
	%--------------------------------
		
	%--
	% matlab level functions
	%--
	
	format.config = [];		% format configuration controls
	
	format.info = [];		% get file info
	
	format.read = [];		% read file into samples
	
	format.write = [];		% write samples to file
	
	%--
	% file level operations
	%--
	
	format.encode = [];		% file to file encoding function (always to format)
	
	format.decode = [];		% file to file decoding function (always to wav)
	
	%--------------------------------
	% FORMAT INFORMATION
	%--------------------------------
	
	% NOTE: formats that do not support seeking are storage only
	
	format.seek = [];			% format HANDLER supports efficient seeking
		
	format.compression = [];	% format supports compression
	
else
	
	format = FORMAT_PERSISTENT;
		
end

%---------------------------------------------------------------------
% SET FIELDS IF PROVIDED
%---------------------------------------------------------------------

if (length(varargin))
	
	%--
	% try to get field value pairs from input
	%--
	
	format = parse_inputs(format,varargin{:});

end


