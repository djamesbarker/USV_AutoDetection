function [f,p] = struct_to_excel(X,p,varargin)

% struct_to_excel - save struct as excel worksheet
% ------------------------------------------------
% 
% [f,p] = struct_to_excel(X,p,f1,...,fn)
%
% Input:
% ------
%  X - structure array
%  p - location of excel file (def: file dialog)
%  f1,...,fn - fields to save to worksheet
%
% Output:
% -------
%  field - file created
%  p - location of file

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

%--
% convert struct to cell array and append field name row
%--

% get fieldnames

field = fieldnames(X)';

% create cell array

Y = cell(length(X) + 1,length(field));
Y(1,:) = field;
Y(2:end,:) = squeeze(struct2cell(X))';

% convert matrix fields to strings

for j = 1:length(field)
	if (~isstr(Y{2,j}) & length(Y{2,j}) > 1)
		for i = 2:length(X) + 1
			Y{i,j} = mat2str(Y{i,j},6);
		end
	end
end

%--
% open excel and add workbook
%--

% open excel

Excel = actxserver('Excel.Application');
set(Excel, 'Visible', 1);

% insert workbook

Workbooks = Excel.Workbooks;
Workbook = invoke(Workbooks, 'Add');

% make specific sheet active

% Sheets = Excel.ActiveWorkBook.Sheets;
% sheet = get(Sheets, 'Item', 1);
% invoke(sheet, 'Activate');

% get active sheet

Activesheet = Excel.Activesheet;

%--
% put matlab array in excel
%--

% compute cell range

ix1 = 'A1';
ix2 = [char(64 + length(field)) num2str(length(X))];
	
% put array in active sheet

ActivesheetRange = get(Activesheet,'Range',ix1,ix2);
set(ActivesheetRange, 'Value', Y);

%--
% save workbook
%--

if (nargin < 2)
	[f,p] = uiputfile('file.xls','Save Excel document as ...');
	invoke(Workbook,'SaveAs',[p,f]);
end

% invoke(Workbook, 'SaveAs', 'C:\Harold\Matlab\sound_tools\myfile.xls');

% To avoid saving the workbook and being prompt to do so,
% uncomment the following code.

Workbook.Saved = 1;
invoke(Workbook, 'Close');

% Quit Excel.
invoke(Excel, 'Quit');
