function [f,p] = uiget_sound_files(in)

% uiget_sound_files - get location of sound files interactively
% -------------------------------------------------------------
%
% [f,p] = uiget_sound_files(type)
%       = uiget_sound_files(sound)
%
% Input:
% ------
%  type - sound type
%  sound - sound structure
%
% Output:
% -------
%  f - filename
%  p - path

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
% $Revision: 498 $
% $Date: 2005-02-03 19:53:25 -0500 (Thu, 03 Feb 2005) $
%--------------------------------

%-----------------------------------------------
% HANDLE INPUT
%-----------------------------------------------

%--
% set default input
%--
if (nargin < 1) || isempty(in)
	in = 'file';
end

%--
% sound type input
%--

if ischar(in)
	
	%--
	% check and normalize input type
	%--
	
	[ignore,type] = is_sound_type(in);
	
	if (isempty(type))
		error('Unrecognized sound type.');
	end
	
	%--
	% set initial directory 
	%--
	
	sound_dir = get_env('xbat_path_sound');
	
%--
% sound input
%--

else
	
	%--
	% get type from sound
	%--
	
	type = in.type;
	
	%--
	% set initial directory
	%--
	
	sound_dir = in.path;
	
end

%-----------------------------------------------
% INITIALIZE
%-----------------------------------------------

%--
% set initial directory
%--

current_dir = pwd;

if isempty(sound_dir)
	
	set_env('xbat_path_sound',current_dir);
	
else
	
	try
		cd(sound_dir);
	catch
		set_env('xbat_path_sound',current_dir); % NOTE: we know this exists
	end
	
end

%-----------------------------------------------
% GET FILE LOCATION
%-----------------------------------------------

%--
% get dialog file filter specification
%--

filter = get_formats_filter;

%--
% get file locations depending on type of sound
%--

switch lower(type)

	%--
	% file
	%--

	case 'file'
		
		% NOTE: 'multiselect' allows creation of many file sounds
		
		% NOTE: there is a known matlab bug when selecting many files
		
        [f,p] = uigetfile2('*.*','Select Sound File(s):','multiselect','on');
	
	%--
	% file stream
	%--
	
	case {'file stream','stream'}
		
		% NOTE: this will allow to select a member of the file stream
		
		p = uigetdir(pwd, 'Select folder containing sound file stream');
		
		f = '__STREAM__';
		
%         [f,p] = uigetfile2(filter,'Select Member of ''File Stream'':');  
	
end
		
%--
% return to original directory
%--

cd(current_dir);

%--
% update sound path environment variable
%--

if isstr(p)
	set_env('xbat_path_sound',p);
end

%--
% return on cancel
%--

% NOTE: we return when the output of uigetfile is neither string or cell

if ~(ischar(f) || iscell(f))
	f = []; p = []; return;
end

if strcmp(f, '__STREAM__')
	f = [];
end

%--
% output as single output
%--

if nargout < 2
	
	%--
	% concatenate path and file names and output
	%--
	
	% NOTE: single files output a string multiple files a cell 
	
	if iscell(f)
		for k = 1:length(f)
			full{k} = [p, f{k}];
		end
	else
		full = [p, f];
	end
	
	f = full;
	
end
