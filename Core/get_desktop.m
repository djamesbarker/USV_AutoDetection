function desktop = get_desktop

% get_desktop - get the desktop folder for the system user
% --------------------------------------------------------
%
% desktop = get_desktop
%
% Output:
% -------
%  desktop - path to the user's desktop

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
% handle platform specific stuff
%--

switch computer
		
    case {'GLNX86', 'GLNXA64', 'HPUX', 'SOL2'}

        [status, desktop] = system('echo ~/Desktop'); desktop(end) = '';
        
    case {'MACI', 'MACI64'}
        
        desktop = '';

    case {'PCWIN', 'PCWIN64'}

        % TODO: figure out how to get this from the registry

        %--
        % get windows info
        %--
        try

            info = get_windows_info;

            if isempty(info)
                desktop = ''; return;
            end

            %--
            % get user desktop folder
            %--

            desktop = ['C:\Documents and Settings\', info.user, '\Desktop'];

        catch

            desktop = xbat_root;

        end

end

% NOTE: check the directory exists

if ~exist_dir(desktop)
    desktop = '';
end
