function [ax2,h2] = clone_axes(h1,ax1,h2)

% clone_axes - clone specified axes from parent
% ---------------------------------------------
%
% [ax2,h2] = clone_axes(h1,ax1,h2)
%
% Input:
% ------
%  h1 - parent of axes to clone
%  ax1 - axes to clone 
%  h2 - parent of cloned axes
%
% Output:
% -------
%  ax2 - cloned axes
%  h2 - parent of cloned axes

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

%---------------------
% HANDLE INPUT
%---------------------

if (nargin < 3)
	h2 = figure; flag = 1;
else
	flag = 0;
end

if (nargin < 2)
	ax = findobj(h1,'type','axes');
end

%---------------------
% CLONE AXES
%---------------------

%--
% clear existing new parent figure
%--

% TODO: make this an option

if (~flag)
	clf(h2,'RESET');
end

%--
% set cloneable properties of new parent figure
%--

set(h2, get_cloneable(h1));

%--
% clone axes
%--

for k = 1:numel(ax)
	prop = get_cloneable(ax(k)); prop, prop.Parent = h2; axes(prop);	
end


%------------------------------------
% GET_CLONEABLE
%------------------------------------

function prop = get_cloneable(obj)

%--
% get all settable properties
%--

prop = get_settable(obj);

%--
% remove callback, current state, and label propperty fields
%--

% NOTE: these contain or may contain stale information

prop = remove_callback_fields(prop);

prop = remove_current_fields(prop);

prop = remove_label_fields(prop);

%--
% remove fields used for identification and state storage, and others
%--

remove = {'Name','Tag','UIContextMenu','UserData'};

prop = remove_field(prop,remove);


% TODO: consider making these separate functions in the same place as 'get_settable'

%------------------------------------
% REMOVE_CALLBACK_FIELDS
%------------------------------------

function prop = remove_callback_fields(prop)

% NOTE: this code relies on a MATLAB naming convention for callback fields

prop = remove_pattern_fields(prop,'Fcn');


%------------------------------------
% REMOVE_CURRENT_FIELDS
%------------------------------------

function prop = remove_current_fields(prop)

% NOTE: this code relies on a MATLAB naming convention for current value fields

prop = remove_pattern_fields(prop,'Current');


%------------------------------------
% REMOVE_LABEL_FIELDS
%------------------------------------

function prop = remove_label_fields(prop)

% NOTE: this code relies on a MATLAB naming convention for current value fields

prop = remove_pattern_fields(prop,'Label');

prop = remove_pattern_fields(prop,'Location');

if (isfield(prop,'Title'))
	prop = rmfield(prop,'Title');
end


%------------------------------------
% REMOVE_PATTERN_FIELDS
%------------------------------------

% TODO: make this a separate function 

function prop = remove_pattern_fields(prop,pat)

% TODO: allow for multiple patterns

%--
% find property fields that match pattern
%--

fields = fieldnames(prop);

ix = find(~cellfun('isempty',strfind(fields,pat)));

if (isempty(ix))
	return;
end

%--
% remove pattern match fields
%--

prop = rmfield(prop,fields(ix));



