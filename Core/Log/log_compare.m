function C = log_compare(A,B)

% log_compare - comparet two logs
% -------------------------------
%
% C = log_compare(A,B)
%
% Input:
% ------
%  A - first log to compare
%  B - second log to compare
%
% Output:
% -------
%  C - log resulting from comparison

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

%-----------------------------------------------------
% CHECK THAT LOGS CORRESPOND TO SAME SOUND
%-----------------------------------------------------

if (sound_compare(A.sound,B.sound) == 0)
	disp(' ');
	error('Logs sounds are different.');
end

%-----------------------------------------------------
% GET EVENT FIELDS AND SORT BY TIME
%-----------------------------------------------------

%--
% get event fields for A and sort by start time
%--

tmp = A.event;

A_t = struct_field(tmp,'time');
A_ch = struct_fiel(tmp,'channel');
A_id = struct_field(tmp,'id');

[ignore,ix] = sort(A_t(:,1));

A_t = A_t(ix,:);
A_ch = A_ch(ix);
A_id = A_id(ix);

%--
% get event fields for B and sort by time
%--

tmp = B.event;

B_t = struct_field(tmp,'time');
B_id = struct_field(tmp,'id');

[ignore,ix] = sort(B_t(:,1));

B_t = B_t(ix,:);
B_ch = B_ch(ix);
B_id = B_id(ix);

%-----------------------------------------------------
% CREATE OUTPUT LOG
%-----------------------------------------------------

% C = log_create([A.path, file_ext(A.file) '_vs_' file_ext(B.file) '.mat'], ...
% 	'color', color_to_rgb('Bright Red'), ...
% 	'linestyle', '--', ...
% 	'linewidth', 1 ...
% );

%-----------------------------------------------------
% COMPUTE MATCHES, FALSE NEGATIVES, AND FALSE POSITIVES
%-----------------------------------------------------

A_n = length(A_t);
B_n = length(B_t);

for k = 1:A_n
	
	j = 1;
		
end
