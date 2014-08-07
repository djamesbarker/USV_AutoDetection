function nice_catch_error(info)

% NOTE: this function displays the unframed error display for 'nice_catch'

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

if ~nargin
	info = lasterror;
end 

%---------------------
% DISPLAY
%---------------------

disp(' MESSAGE:');
disp(' ');

if ~isfield(info, 'identifier') || isempty(info.identifier)
	disp(['   ', info.message]);
else
	disp(['   ', info.message, ' (', info.identifier, ')']);
end

disp(' ');

disp(' STACK:');

% NOTE: try to get stack information if not available

full = 1;

if ~isfield(info, 'stack')
	try
		info.stack = dbstack('-completenames'); info.stack(1:2) = []; full = 0;
	catch
		info.stack = [];
	end
end

if ~isempty(info.stack)
	
	if ~full
		disp(' ');
		disp('   WARNING: Only partial stack information is available.');
	end

	disp(' ');

	stack_disp(info.stack);
	
else
	
	disp(' ');
	disp('   WARNING: No stack information is available.');
	
end
