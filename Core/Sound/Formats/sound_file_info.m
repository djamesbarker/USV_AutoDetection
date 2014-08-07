function info = sound_file_info(f)

% sound_file_info - get sound file information
% --------------------------------------------
%
% info = sound_file_info(f)
%
% Input:
% ------
%  f - file locations
%
% Output:
% -------
%  info - normalized sound file info

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
% $Revision: 498 $
% $Date: 2005-02-03 19:53:25 -0500 (Thu, 03 Feb 2005) $
%--------------------------------

%---------------------------------------------
% HANDLE INPUT
%---------------------------------------------

%--
% handle multiple files recursively
%--

if iscell(f)
	
	info = {};

	for k = 1:length(f)	
		
		info_k = sound_file_info(f{k});
		
		info{end + 1} = info_k;	
		
	end
	
	info = [info{:}];
	
	return;
	
end
		
%---------------------------------------------
% GET FORMAT SPECIFIC INFO
%---------------------------------------------

error_prefix = 'Unable to get sound file information from ';

%--
% try to get format handler 
%--

format = get_file_format(f);

%--
% read file using handler
%--

try
	info = format.info(f);
catch
	info = []; disp([error_prefix, '''', f, ''': ']); disp(lasterr); return;
end
		
% NOTE: this override of the lower format info is dubious

info.format = format.name;

%---------------------------------------------
% NORMALIZE INFO
%---------------------------------------------

% TODO: put this into a separate function and use 'struct_copy' when it is ready

% NOTE: the only requirement for this to work is that info fields are named the same

ninfo = info_create;

ninfo_field = fieldnames(ninfo);

info_field = fieldnames(info);

%--
% copy common fields from info to normalized info
%--

% TODO: consider making this type of copy a function

for k = 1:length(info_field)
	
	if ~isempty(find(strcmp(info_field{k}, ninfo_field)))
		ninfo.(info_field{k}) = info.(info_field{k});
	end
		
end

%--
% copy format specific fields into the 'info' output field
%--

format_field = setdiff(info_field, ninfo_field);

if ~isempty(format_field)
	
	for k = 1:length(format_field)
		ninfo.info.(format_field{k}) = info.(format_field{k});
	end
	
end

%--
% output standardized info structure
%--

info = ninfo;

%---------------------------------------------
% ADD SYSTEM INFORMATION
%---------------------------------------------

info.file = f;

% TODO: consider an option to skip this

if (1)
	
	sys = dir(f);
	
	info.name = sys.name;
	
	info.date = sys.date;
	
	info.bytes = sys.bytes;

end

