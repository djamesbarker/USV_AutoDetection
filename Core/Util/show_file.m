function in = show_file(in)

% show_file - show file
% ---------------------
%
% out = show_file(in)
%
% Input:
% ------
%  in - file or directory path to show
%
% Output:
% -------
%  out - file shown, empty is input does not exist

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
% check input
%--

if ~ischar(in)
	error('File to show must be a string.');
end

% NOTE: return empty if we did not find something to show

if ~exist(in, 'file') && ~exist(in, 'dir')
	in = ''; return;
end

%--
% show file
%--

switch computer
	
	case {'PCWIN', 'PCWIN64'}
		
		% NOTE: we use the system call display for files so we can select
		
        if isdir(in)
			winopen(in); % eval(['!explorer /n,', path_parts(f), ' &']);
		else
			eval(['!explorer /n,/select,', in, ' &']);
        end
        
    case 'GLNX86'
 
        if ~isdir(in)
            in = fileparts(in);
        end
        
        commands = {'nautilus'};
                     
        for k = 1:length(commands) 
            
            [status, result] = system([commands{k}, ' ', in]); 
            
            if ~status
                break;
            end
              
        end    
		
    case {'MACI64', 'MACI'}
        
        system(['open ',in]);

end
