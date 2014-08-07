function info = get_windows_info

% get_windows_info - get some windows info
% ----------------------------------------
% 
% info = get_windows_info
%
% Output:
% -------
%  info - some windows info

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
% $Revision: 6324 $
% $Date: 2006-08-25 01:36:37 -0400 (Fri, 25 Aug 2006) $
%--------------------------------

% NOTE: this functions seems very fragile, due to the complexity and
% possible volatility of the registry

%--
% return for non-windows
%--

if ~ispc
	info = []; return;
end

%--
% user
%--

info.user = winqueryreg( ...
	'HKEY_LOCAL_MACHINE', ...
	'SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon', ...
	'DefaultUserName' ...
);

%--
% computer
%--

info.computer.name = winqueryreg( ...
	'HKEY_LOCAL_MACHINE', ...
	'SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon', ...
	'DefaultDomainName' ...
);

info.computer.alias = winqueryreg( ...
	'HKEY_LOCAL_MACHINE', ...
	'SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon', ...
	'AltDefaultDomainName' ...
);

info.computer.owner = winqueryreg( ...
	'HKEY_LOCAL_MACHINE', ...
	'SOFTWARE\Microsoft\Windows NT\CurrentVersion', ...
	'RegisteredOwner' ...
);

%--
% matlab
%--

info.matlab.name = winqueryreg( ...
	'HKEY_LOCAL_MACHINE', ...
	'SOFTWARE\MathWorks', ...
	'Name' ...
);

info.matlab.company = winqueryreg( ...
	'HKEY_LOCAL_MACHINE', ...
	'SOFTWARE\MathWorks', ...
	'Company' ...
);

%--
% windows
%--

info.windows.name = winqueryreg( ...
	'HKEY_LOCAL_MACHINE', ...
	'SOFTWARE\Microsoft\Windows NT\CurrentVersion', ...
	'ProductName' ...
);

info.windows.id = winqueryreg( ...
	'HKEY_LOCAL_MACHINE', ...
	'SOFTWARE\Microsoft\Windows NT\CurrentVersion', ...
	'ProductId' ...
);
