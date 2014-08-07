function out = write_flac(f,X,r,opt)

% write_flac - write samples to sound file
% ----------------------------------------
%
%  opt = write_flac(f)
%
% flag = write_flac(f,X,r,opt)
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
%  flag - success flag

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

%---------------------------------------
% SET PERSISTENT VARIABLES
%---------------------------------------

%--
% create single persistent temporary file name
%--

persistent FLAC_WRITE_TEMP;

if (isempty(FLAC_WRITE_TEMP))
	FLAC_WRITE_TEMP = [tempdir, 'FLAC_WRITE_TEMP.wav'];
end

%---------------------------------------
% HANDLE INPUT
%---------------------------------------

%--
% set default encoding options
%--

if ((nargin < 4) || isempty(opt))
	
	% NOTE: we get the options as if coming from WAV
	
	opt = encode_flac('temp.wav');
	
end 

%--
% return default options
%--
	
if (nargin == 1)
	out = opt; return;
end

%---------------------------------------
% DECODE USING CLI HELPER
%---------------------------------------

%--
% create temporary file
%--

% NOTE: the temporary file is created using default encoding options

% write_libsndfile(FLAC_WRITE_TEMP,X,r);

write_libsndfile(f,X,r);

out = [];

% %--
% % encode temporary file to flac
% %--
% 
% out = sound_file_encode(FLAC_WRITE_TEMP,f,opt);
% 
% out = ~isempty(out);
