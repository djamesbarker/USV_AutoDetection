function log_fileupdate(str)

% log_fileupdate - update filenames in log after renaming files
% -------------------------------------------------------------
% 
% log_fileupdate(str)
%
% Input:
% ------
%  str - filename update string
%
% Notes:
% ------
%  1. 
%
%     '*_yyyylldd_hhmmss' -> ID5_20010314_203412.aif -> March 14,2001 20:34:12
%     'yylldd_hhmmss' -> 010105_034512.wav -> January 5,2001 03:45:12

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
% open log file and load variables
%--

if (nargin < 2)
	
	%--
	% open log file
	%--
	
	try
		[fn_in,p_in] = uigetfile2('*.mat','Select log file to update filenames:');
		tmp = load([p_in,fn_in]);
	catch
		disp(' ');
		warning('Get log file was cancelled.');
	end
	
	%--
	% get variables
	%--
	
	try 
		geom = tmp.arrGeom;
		sound = tmp.fileList;
		log = tmp.output;
		new_log = tmp.new_log;
	catch
		disp(' ');
		error('File does not contain needed log variables.');
	end
	
end

%--
% select output file location
%--

tmp = findstr(fn_in,'.'); 
fn = fn_in(1:tmp(end) - 1);
name = [p_in, fn, '_new.mat'];

[fn,p] = uiputfile( ...
	name, ...
	'Choose location of output text file:' ...
);
