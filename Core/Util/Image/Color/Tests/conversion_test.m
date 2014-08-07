function info = conversion_test(X)

% conversion_test - test colorspace conversions
% ---------------------------------------------
%
%  info = conversion_test(X)
%
% Input:
% ------
%  X - image to use in tests
%
% Output:
% -------
%  info - error reporting on the various transformations

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
% create list of conversion pairs
%--

C = { ...
	'rgb_to_hsv','hsv_to_rgb'; ...
	'rgb_to_lab','lab_to_rgb'; ...
	'rgb_to_opp','opp_to_rgb'; ...
	'rgb_to_xyz','xyz_to_rgb'; ...
	'rgb_to_rgbnl','rgbnl_to_rgb'; ...
	'rgb_to_luv','luv_to_rgb' ...
};

%--
% create conversion information structure
%--

tmp.conversion = '';
tmp.time = [];
tmp.error = [];

info = tmp;

%--
% run color conversion tests
%--

% get number of available conversions

n = length(C);

% loop over conversions

for k = 1:n
	
	%--
	% compute and time identity transformation
	%--
	
	disp(' ');
	disp(['Computing ''' C{k,1} ''' identity ...']);
	disp('------------------------------------');
		
	try
		
		tic;
		Y = feval(C{k,2},feval(C{k,1},X));
		t = toc;
		
	catch
		
		disp(' ');
		warning(['Problems computing ''' C{k,1} ''' type identity.']);
		
		info(k) = tmp;
		
		info(k).conversion = C{k,1};
		info(k).time = 'ERROR';
		info(k).error = 'ERROR';
		
		continue;
		
	end
	
	%--
	% compute error
	%--
	
	e = fast_min_max(double(Y) - double(X));
	
	%--
	% collect info
	%--
	
	info(k) = tmp;
	
	info(k).conversion = C{k,1};
	info(k).time = t;
	info(k).error = e;
	
	%--
	% display info
	%--
	
	disp(['time:  ' num2str(t) ' sec']);
	disp(['error: ' mat2str(e,4)]);
	disp(['error: ' mat2str(e./eps,4)]);
	disp(' ');
	
end
	
	
	
	
