function opt = tsvn_options(varargin)

% tsvn_options - get and set 'TortoiseSVN' options
% ------------------------------------------------
%
% opt = tsvn_options
%
% tsvn_options('field', value, ...)
%
% Input:
% ------
%  field - 'TortoiseSVN' option name
%  value - 'TortoiseSVN' option value
%
% Output:
% -------
%  opt - 'TortoiseSVN' options structure

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
% $Revision: 1180 $
% $Date: 2005-07-15 17:22:21 -0400 (Fri, 15 Jul 2005) $
%--------------------------------

% NOTE: there is some interesting dynamic code in this function

%--
% set prototype structure and defaults
%--

persistent TSVN_OPTION;

if isempty(TSVN_OPTION)
		
	TSVN_OPTION.block = 0;
	
	TSVN_OPTION.close = 0;
	
end

%--
% call set or get depending on number of inputs
%--

% NOTE: the exception creates an independent get of defaults

try
	if ~nargin
		opt = get_tsvn_options(TSVN_OPTION);
	else
		opt = set_tsvn_options(TSVN_OPTION, varargin{:});
	end
catch	
	opt = TSVN_OPTION;
end


%----------------------------------------------------------
% GET_TSVN_OPTIONS
%----------------------------------------------------------

function opt = get_tsvn_options(opt)

fields = fieldnames(opt);

for k = 1:length(fields)

	%--
	% build option enviroment name
	%--
	
	var = ['tsvn_', fields{k}];

	%--
	% get value for options field from environment variable
	%--
	
	value = get_env(var);

	if ~isempty(value)
		opt.(fields{k}) = value;
	end

end


%----------------------------------------------------------
% SET_TSVN_OPTIONS
%----------------------------------------------------------

function opt = set_tsvn_options(opt, varargin)

%--
% get and update options structure
%--

opt = get_tsvn_options(opt);

opt = parse_inputs(opt, varargin{:});

%--
% set environment variables
%--

fields = fieldnames(opt);

for k = 1:length(fields)

	%--
	% build option enviroment name
	%--
	
	var = ['tsvn_', fields{k}];

	%--
	% set value of environment variables from option fields
	%--
	
	set_env(var, opt.(fields{k}));
	
end

