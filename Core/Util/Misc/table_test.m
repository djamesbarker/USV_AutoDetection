function table = table_test(data,labels)

% table_test - playing with the idea of using tables
% --------------------------------------------------

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
% $Revision: 976 $
% $Date: 2005-04-25 19:27:22 -0400 (Mon, 25 Apr 2005) $
%--------------------------------

% TODO: break this into a series of 'set' and 'get' for a single object

% NOTE: relevant properties are spread across a range of objects

% NOTE: eventually add this to the available 'control' widgets

%-----------------------------------------
% HANDLE INPUT
%-----------------------------------------

if ((nargin < 2) || isempty(labels))
	labels = {'One', 'Two', 'Three', 'Four', 'Five'};
end

if ((nargin < 1) || isempty(data))
	data = rand(5);
end

%-----------------------------------------
% CREATE TEST
%-----------------------------------------

%--
% create parent figure and table
%--

par = figure;

%--
% create table
%--

% TODO: there are a number of table properties to be set at creation

table = uitable(par, data, labels, 'rowheight', 30);

%--
% set figure and table properties
%--

% NOTE: we pass the table handle to the resize function

set(par, ...
	'color',get(0,'defaultuicontrolbackgroundcolor'), ...
	'resizefcn',{@table_resize,table} ...
);

table_resize(par,[],table);


%--------------------------------------------------------------------
% TABLE_RESIZE
%--------------------------------------------------------------------

function table_resize(obj,eventdata,table)

%--
% get figure position in pixels
%--

units = get(obj,'units'); set(obj,'units','pixels');

pos = get(obj,'position');

set(obj,'units',units);

%--
% set table container position
%--

cont = findobj(obj,'type','uicontainer');

margin = 3 * [12, 8, 16, 8]; % NOTE: the mnemonic is TRBL

pos = [ ...
	margin(4), margin(3), ...
	pos(3) - (margin(2) + margin(4)), ...
	pos(4) - (margin(1) + margin(3)) ...
];

set(cont,'position',pos);

%--
% set some java table properties
%--

% RESIZE MODE 

jtable = get(table,'Table');

set(jtable,'AutoResizeMode',1);

% TABLE FONT

jfont = java.awt.Font('Courier',0,16);

set(jtable,'Font',jfont);

%---------------------------
% get table data 
%---------------------------

%--
% get java object array
%--

jdata = get(table,'Data');

%--
% convert to matlab cell array
%--

data = cell(jdata);

% NOTE: a further conversion into a matrix works if the array is numeric

% data = cell2mat(data);

%---------------------------
% set table data
%---------------------------

%--
% create matlab array
%--

m = 200; n = 2; 

in = randn(m,n);

%--
% convert to java array
%--

clear jdata;

for j = n:-1:1
	for i = m:-1:1
		jdata(i,j) = java.lang.Float(in(i,j));
	end
end
	
set(table,'Data',jdata);

%---------------------------
% get table column names
%---------------------------

%--
% get java array
%--

jnames = get(table,'ColumnNames');

%--
% convert to matlab string cell array
%--

names = cell(jnames);

%---------------------------
% set table columns names
%---------------------------

%--
% matlab string cell array names
%--

% NOTE: we permute the column names

in = names(randperm(length(names)));

%--
% convert to java array and set
%--

clear jnames;

for k = length(in):-1:1
	jnames(k) = java.lang.String(in{k});
end

set(table,'ColumnNames',jnames);


%--
% display settable properties of relevant table objects
%--

% set1 = set(table)
% 
% set2 = set(jtable)

