function varargout = warn_dialog(WarnString,DlgName,Replace)

% warn_dialog - warning type dialog box
% -------------------------------------
%
% h = warn_dialog(str,name)
%
% Input:
% ------
%  str - warning string or cell array of strings
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

%WARNDLG Warning dialog box.
%  HANDLE = WARNDLG(WARNSTRING,DLGNAME) creates an warning dialog box
%  which displays WARNSTRING in a window named DLGNAME.  A pushbutton
%  labeled OK must be pressed to make the warning box disappear.
%
%  HANDLE = WARNDLG(WARNSTRING,DLGNAME,CREATEMODE) allows CREATEMODE options
%  that are the same as those offered by MSGBOX.  The default value
%  for CREATEMODE is 'non-modal'.
%
%  WARNSTRING may be any valid string format.  Cell arrays are
%  preferred.
%
%  See also MSGBOX, HELPDLG, QUESTDLG, ERRORDLG, WARNING.

%  Author: L. Dean
%  Copyright 1984-2002 The MathWorks, Inc.
%  $Revision: 1.0 $  $Date: 2003-07-06 13:36:11-04 $

if (nargin == 0)
	WarnString = 'This is the default warning string.';
end

if (nargin < 2)
	DlgName = 'Warning Dialog';
end

if (nargin < 3)
	Replace = 'non-modal';
end

if (ischar(WarnString) & ~iscellstr(WarnString))
	WarnString = cellstr(WarnString);
end

if ~iscellstr(WarnString)
	error('WarnString should be a string or cell array of strings');
end

WarnStringCell = cell(0);

for i = 1:length(WarnString)
	WarnStringCell{end + 1} = xlate(WarnString{i});
end

handle = msg_box(WarnStringCell,DlgName,'warn',Replace);

if (nargout == 1)
	varargout(1) = {handle};
end
