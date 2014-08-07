function strip_flash(in, pre)

% strip_flash - display file stripped of comment and empty lines
% --------------------------------------------------------------
%
% strip_flash(in, pre)
%
% Input:
% ------
%  in - file to strip and flash
%  pre - prefix comment pattern

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
% $Revision: 1600 $
% $Date: 2005-08-18 17:41:06 -0400 (Thu, 18 Aug 2005) $
%--------------------------------

%------------------------------
% HANDLE INPUT
%------------------------------

%--
% check existence of input file and get file extension
%--

in = which(in);

if ~exist(in, 'file')
	error(['Unable to find input file: ''', in, '''.']);
end

[ignore, ignore, ext] = fileparts(in);

%--
% set default prefix based on file extension if needed
%--

if (nargin < 2)
	
	% TODO: make this into function
	
	switch ext(2:end)
		
		case 'm'
			pre = '%';
			
		case 'c'
			pre = '//';
			
		case 'pl'
			pre = '#';
			
		otherwise
			pre = '';
			
	end
	
end

%------------------------------
% STRIP AND FLASH
%------------------------------

%--
% create temp filename with same file extension
%--

out = [tempname, ext];

%--
% process file configured for stripping
%--

% TODO: allow empty line compression somehow

opt = file_process; opt.pre = pre; opt.skip = 1;

file_process(out, in, [], opt);

%--
% flash file
%--

edit(out); delete(out);
