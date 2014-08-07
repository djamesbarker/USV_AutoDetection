function format = get_formats(flag, varargin)

% get_formats - get available sound file formats
% ----------------------------------------------
%
% format = get_formats(flag, 'field', value, ...)
%
% Input:
% ------
%  flag - update flag (def: 0)
%  field - format field name
%  value - format field value
%
% Output:
% -------
%  format - selected formats

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
% $Revision: 689 $
% $Date: 2005-03-09 22:14:37 -0500 (Wed, 09 Mar 2005) $
%--------------------------------

%---------------------------------------------------------------
% HANDLE INPUT
%---------------------------------------------------------------

%--
% set update flag
%--

if (nargin < 1) || isempty(flag)
	flag = 0;
end

%---------------------------------------------------------------
% GET AVAILABLE FORMATS
%---------------------------------------------------------------

%-----------------------------------
% USE CACHED FORMATS
%-----------------------------------

persistent FORMAT_PERSISTENT;

if ~isempty(FORMAT_PERSISTENT) && ~flag
	
	%--
	% copy formats from persistent array
	%--
	
	format = FORMAT_PERSISTENT;
	
%-----------------------------------
% REBUILD FORMATS
%-----------------------------------

else
		
	%-----------------------------------
	% GET FORMAT DIRECTORIES
	%-----------------------------------

	%--
	% check that formats parent directory exists
	%--

	% NOTE: this is more flexible but we need to handle multiple matches
	
% 	parent_info = what(['Sound', filesep, 'Formats']);
% 	
% 	parent_dir = parent_info.path;
	
	parent_dir = [xbat_root, filesep, 'Core', filesep, 'Sound', filesep, 'Formats'];

	if ~exist(parent_dir, 'dir')

		disp(' ');
		warning(['Formats directory ''' parent_dir ''' does not exist.']);

		format = [];

		return;

	end

	%--
	% get specific format directories
	%--

	format_dir = get_field(what_ext(parent_dir),'dir');

	%--
	% remove directories not containing extensions
	%--

	% NOTE: this may not be needed in the future

	for k = length(format_dir):-1:1

		% NOTE: remove private and source directories from consideration

		if ( ...
			strcmpi(format_dir{k},'private') || ...
			strcmpi(format_dir{k},'mex_source') || ...
			strcmpi(format_dir{k},'.svn') ...
		)
			format_dir(k) = [];	
		end

	end

	%-----------------------------------
	% GET FORMATS
	%-----------------------------------

	if length(format_dir)

		j = 0;

		for k = 1:length(format_dir)

			%--
			% try to get format information
			%--

			try

				% NOTE: possibly check for existence of file

				splash_wait_update(get_splash, ['loading ''', format_dir{k}, ''' format ...']);
				
				fmt = feval(['format_', lower(format_dir{k})]);
				
			catch

				%--
				% display last error
				%--

				disp(' ');
				disp(lasterr);

				%--
				% display failure to load format
				%--

				disp(' ');
				warning(['Failed to get format from ''' format_dir{k} '''.']);

				continue;

			end

			%--
			% update format registry array
			%--

			j = j + 1;
			
			if (j == 1)
				format = fmt;
			else
				format(j) = fmt;
			end

		end

		%--
		% return empty
		%--

		if (j == 0)
			format = [];
		end

		%--
		% remove formats not associated to file extensions
		%--

		% NOTE: these are abstract formats never called directly

		for k = length(format):-1:1
			if isempty(format(k).ext)
				format(k) = [];
			end
		end

		%--
		% output results in sorted order
		%--

		if (j > 1)
			[ignore,ix] = sort(struct_field(format,'name'));
			format = format(ix);
		end

	%--
	% return empty 
	%--

	else

		format = [];

	end
	
	%--
	% copy formats to persistent array
	%--
	
	FORMAT_PERSISTENT = format;
	
end

%---------------------------------------------------------------
% SELECT FROM AVAILABLE FORMATS
%---------------------------------------------------------------

%--
% consider selection when we have something to select and criteria
%--

if (length(varargin) && ~isempty(format))
	
	%--
	% get field value pairs from input
	%--
	
	[field,value] = get_field_value(varargin);
	
	%--
	% loop over fields
	%--
	
	for j = 1:length(field)

		%--
		% check that extension field is available
		%--
				
		if (isfield(format(1),field{j}))
			
			%--
			% handle extension field matching in different ways
			%--
			
			switch (field{j})
			
				%--
				% select format to handle file extension
				%--
				
				case ('ext')

					for k = length(format):-1:1

						if (isempty(find(strcmpi(value{j},format(k).ext))))
							format(k) = [];
						end

					end

				%--
				% select based on extension field values
				%--
					
				otherwise

					for k = length(format):-1:1

						if (~isequal(format(k).(field{j}),value{j}))
							format(k) = [];
						end

					end
					
			end
		
		end
			
	end
	
	%--
	% return empty
	%--
	
	if (isempty(format))
		format = [];
	end
	
end
