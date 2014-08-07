function varargout = help_dialog(HelpString,DlgName)

% help_dialog - help type dialog box
% ----------------------------------
%
% h = help_dialog(str,name)
%
% Input:
% ------
%  str - help string or cell array of strings
%  name - name of dialog box
%
% Output:
% -------
%  h - handle to dialog box figure

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

%HELPDLG Help dialog box.
%  HANDLE = HELPDLG(HELPSTRING,DLGNAME) displays the 
%  message HelpString in a dialog box with title DLGNAME.  
%  If a Help dialog with that name is already on the screen, 
%  it is brought to the front.  Otherwise a new one is created.
%
%  HelpString will accept any valid string input but a cell
%  array is preferred.
%
%  See also MSGBOX, QUESTDLG, ERRORDLG, WARNDLG.

%  Author: L. Dean
%  Copyright 1984-2002 The MathWorks, Inc.
%  $Revision: 1.0 $  $Date: 2003-07-06 13:36:05-04 $

if nargin==0,
   HelpString ={'This is the default help string.'};
end
if nargin<2,
   DlgName = 'Help Dialog';
end

if ischar(HelpString) & ~iscellstr(HelpString)
    HelpString = cellstr(HelpString);
end
if ~iscellstr(HelpString)
    error('HelpString should be a string or cell array of strings');
end

HelpStringCell = cell(0);
for i = 1:length(HelpString)
    HelpStringCell{end+1} = xlate(HelpString{i});
end

handle = msg_box(HelpStringCell,DlgName,'help','replace');

if nargout==1,varargout(1)={handle};end
