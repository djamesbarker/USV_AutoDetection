function varargout = error_dialog(ErrorString,DlgName,Replace)

% error_dialog - error type dialog box
% ------------------------------------
%
% h = error_dialog(str,name,mode)
%
% Input:
% ------
%  str - error string or cell array of strings
%  name - name of dialog box
%  mode - creation mode for dialog
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

%ERRORDLG Error dialog box.
%  HANDLE = ERRORDLG(ErrorString,DlgName,CREATEMODE) creates an 
%  error dialog box which displays ErrorString in a window 
%  named DlgName.  A pushbutton labeled OK must be pressed 
%  to make the error box disappear.  
%
%  ErrorString will accept any valid string input but a cell 
%  array is preferred.
%
%  ERRORDLG uses MSGBOX.  Please see the help for MSGBOX for a
%  full description of the input arguments to ERRORDLG.
%  
%  See also MSGBOX, HELPDLG, QUESTDLG, WARNDLG.

%  Author: L. Dean
%  Copyright 1984-2002 The MathWorks, Inc.
%  $Revision: 1.0 $  $Date: 2003-07-06 13:36:02-04 $

NumArgIn = nargin;
if NumArgIn==0,
   ErrorString = {'This is the default error string.'};
end

if NumArgIn<2,  DlgName = 'Error Dialog'; end
if NumArgIn<3,  Replace='non-modal'     ; end

% Backwards Compatibility
if ischar(Replace),
  if strcmp(Replace,'on'),
    Replace='replace';
  elseif strcmp(Replace,'off'),
    Replace='non-modal';
  end
end

if ischar(ErrorString) & ~iscellstr(ErrorString)
    ErrorString = cellstr(ErrorString);
end
if ~iscellstr(ErrorString)
    error('Errorstring should be a string or cell array of strings');
end

ErrorStringCell = cell(0);
for i = 1:length(ErrorString)
    ErrorStringCell{end+1} = xlate(ErrorString{i});
end

handle = msg_box(ErrorStringCell,DlgName,'error',Replace);
if nargout==1,varargout(1)={handle};end
