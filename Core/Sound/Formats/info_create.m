function info = info_create(varargin)

% info_create - create info structure
% -----------------------------------
%
%  info = info_create
%
% Output:
% -------
%  info - info structure

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
% CREATE INFO STRUCTURE
%---------------------------------------------------------------------

persistent INFO_PERSISTENT;

if isempty(INFO_PERSISTENT)
	
	%--------------------------------
	% SYSTEM INFORMATION
	%--------------------------------
	
	info.name = [];			% file name
	
	info.format = [];		% human readable format name (match to available formats)
	
	info.file = [];			% file location (full path)
	
	info.date = [];			% last modification date
	
	info.bytes = [];		% size of file in bytes
	
	%--------------------------------
	% FILE CONTENT INFORMATION
	%--------------------------------
	
	info.channels = [];		% number of channel in file
	
	info.samplerate = [];	% samplerate in hertz
	
	info.samplesize = [];	% number of bits per sample
	
	info.samples = [];		% number of samples in file
	
	info.duration = [];		% duration of file (convenience field)
	
	%--------------------------------
	% FORMAT INFORMATION
	%--------------------------------
	
	info.info = [];	% format specific file information
	
	
else
	
	info = INFO_PERSISTENT;
		
end

%---------------------------------------------------------------------
% SET FIELDS IF PROVIDED
%---------------------------------------------------------------------

if length(varargin)
	
	%--
	% try to get field value pairs from input
	%--
	
	info = parse_inputs(info, varargin{:});

end


