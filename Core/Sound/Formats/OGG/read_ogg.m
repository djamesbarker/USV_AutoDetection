function [X,opt] = read_ogg(f,ix,n,ch,opt)

% read_flac - read samples from sound file
% ----------------------------------------
%
% [X,opt] = read_flac(f,ix,n,ch,opt)
%
% Input:
% ------
%  f - file location
%  ix - initial sample
%  n - number of samples
%  ch - channels to select
%  opt - conversion request options
%
% Output:
% -------
%  X - samples from sound file
%  opt - updated conversion options

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
	
f = f.file;

%---------------------------------------
% SET PERSISTENT VARIABLES
%---------------------------------------

%--
% set location of command-line utility
%--

persistent OGG OGG_READ_TEMP;

if (isempty(OGG))
	
	OGG = [fileparts(mfilename('fullpath')), filesep, 'oggdec.exe'];
	
	% NOTE: use a single temporary file to avoid name creation and delete
	
	OGG_READ_TEMP = [tempdir, 'OGG_READ_TEMP'];
	
end

%---------------------------------------
% DECODE USING CLI HELPER
%---------------------------------------
	
temp = [OGG_READ_TEMP, int2str(rand_ab(1,1,10^6)), '.wav'];

%--
% decode flac to temporary file
%--

cmd_str = [ ...
	'"', OGG, '" -Q', ... % NOTE: make the decoding silent
	' -o', temp, ... % NOTE: force the file to be written
	' "', f, '"' ...
];

system(cmd_str);

%--
% load data from temporary sound file
%--
	
X = read_libsndfile(temp,ix,n,ch);

%--
% delete temporary file
%--

delete(temp);
