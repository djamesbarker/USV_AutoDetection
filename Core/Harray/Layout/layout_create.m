function layout = layout_create(row, col, label)

% layout_create - create hierarchical array level configuration
% -------------------------------------------------------------
%
% layout = layout_create(row, col, label)
%
% Input:
% ------
%  row - number of rows or row labels
%  col - number of columns or column labels
%  label - layout label
%
% Output:
% -------
%  layout - layout structure

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

% TODO: implement field value input to allow more configuration on create

%--------------------------------------------
% HANDLE INPUT
%--------------------------------------------

%--
% set default name
%--

if nargin < 3
	label = '';
end

if ~ischar(label) || (~isempty(label) && ~no_seps(label))
	error('Layout label must be a string containing no tag separators.');
end

% TODO: add some checking on label inputs, also improve the row and col

%--
% set default layout size
%--

if nargin < 1
	row = 2; col = 2;
end

if nargin < 2
	col = row;
end

if ~proper_dim_input(row) || ~proper_dim_input(col)
	error('Dimension input must be an integer or a collection of tags.');
end

%--------------------------------------------
% CREATE LAYOUT
%--------------------------------------------

layout.label = label;

%--
% set layout units and current scale
%--

layout.units = 'centimeters';

layout.scale = 1;

%--
% set tool bars
%--

% TODO: allow for multiple toolbars, use a name in some way

layout.tool.on = 0;

layout.tool.size = 0.65;

layout.tool.name = 'DEFAULT';

%--
% set status bar
%--

layout.status.on = 0;

layout.status.size = 0.65;

%--
% set colorbar
%--

layout.color.on = 0;

layout.color.pad = 0.5;

layout.color.size = 1;

%--
% set layout margins
%--

% NOTE: the mnemonic for this margin order is TRBL ('trouble')

layout.margin = 0.5 * ones(1, 4); 

% NOTE: the larger value for top margin and row padding allow titles

layout.margin(1:3) = 0.7;

%--
% set row and column descriptions
%--

% NOTE: the pad values are for the spacing between axes in each dimension

layout.row = dim_create(row, 0.75);

layout.col = dim_create(col, 0.5);


%--------------------------------------------
% DIM_CREATE
%--------------------------------------------

function dim = dim_create(in, pad)

% dim_create - create structure to handle layout dimension
% --------------------------------------------------------
%
% dim = layout_dim(in, pad)
%
% Input:
% ------
%  in - dimension input
%  pad - uniform padding
%
% Output:
% -------
%  dim - layout dimension description

if iscellstr(in)
	dim.label = in; n = length(in);
else
	dim.label = {}; n = in;
end

dim.size = n;

if n > 0
	dim.frac = ones(1, n) / n; dim.pad = pad * ones(1, n - 1);
else
	dim.frac = []; dim.pad = [];
end


%--------------------------------------------
% PROPER_DIM_INPUT
%--------------------------------------------

function value = proper_dim_input(in)

% proper_dim_input - check dimension input
% ----------------------------------------
%
% value = proper_dim_input(in)
%
% Input:
% ------
%  in - dimension input
%
% Output:
% -------
%  value - result of test

value = iscellstr(in) && no_seps(in);

if ~value
	value = isnumeric(in) && (length(in) == 1) && (floor(in) == in);
end


%--------------------------------------------
% NO_SEPS
%--------------------------------------------

function value = no_seps(in, sep) 

% no_seps - check strings in cell do not contain tag separators
% -------------------------------------------------------------
%
% value = no_seps(in, sep) 
%
% Input:
% ------
%  in - set of proposed tags
%  sep - tag separator
%
% Output:
% -------
%  value - result of test

if nargin < 2
	sep = '::';
end

if ischar(in) 
	in = {in};
end 

for k = 1:length(in)
	if ~isempty(strfind(in{k}, sep))
		value = 0; return;
	end
end

value = 1;
