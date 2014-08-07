function out = sound_file_write(f, X, r, opt)

% sound_file_write - write samples to sound file
% ----------------------------------------------
%
% opt = sound_file_write(f)
%
% out = sound_file_write(f, X, r, opt)
%
% Input:
% ------
%  f - file location
%  X - samples to write to file
%  r - sample rate
%  opt - format specific write options
%
% Output:
% -------
%  opt - format specific write options
%  out - number of bytes output to file

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
% $Revision: 587 $
% $Date: 2005-02-22 23:28:55 -0500 (Tue, 22 Feb 2005) $
%--------------------------------

% TODO: check for real samples matrix, and positive integer samplerate

% TODO: develop an 'options' and 'option_controls' framework for configuration

%--------------------------------------------------
% HANDLE INPUT
%--------------------------------------------------

%--
% try to get file format
%--

format = get_file_format(f);

%--
% check for read only format
%--

if isempty(format.write)
	
	disp(['WARNING: ''', format.name, ''' is a read-only format.']); 
	
	out = 0; temp = ''; return;
	
end

%--
% set default options if needed
%--

if (nargin < 4)
	opt = format.write(f);
end

% NOTE: return format specific write options if needed

if (nargin == 1)
	out = opt; return;
end

%--------------------------------------------------
% WRITE SAMPLES TO FILE
%--------------------------------------------------

% TODO: collect information on the write performance of the various formats

%--
% write file using handler
%--

% NOTE: the out flag here simply indicates success in writing

out = format.write(f, X, r, opt);

%--
% get number of bytes written to file from system
%--

% NOTE: convert out from success flag to number of bytes written

if (nargout & out)

	% NOTE: block on file existence to get bytes
	
	while (~exist(f,'file'))
		pause(0.025);
	end
	
	out = dir(f); out = out.bytes;
	
end
