function [X,opt] = read_libsndfile(f,ix,n,ch,opt)

% read_libsndfile - read samples from sound file
% ----------------------------------------------
%
% [X,opt] = read_libsndfile(f,ix,n,ch,opt)
%
% Input:
% ------
%  f - file info
%  ix - initial sample
%  n - number of samples
%  ch - channels to select
%  opt - conversion options
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

%------------------------------------
% READ SAMPLES FROM FILE
%------------------------------------

%--
% get file from file info
%--

% NOTE: in this case we only need the file name

f = f.file;

%--
% convert file string to C string
%--

% NOTE: this string replacement handles network files

str = strrep(f,'\\','??');

str = strrep(str,'\','\\');

str = strrep(str,'??','\\');

%--
% create sample class prototype for configuring MEX if needed
%--

if ((nargin < 5) || isempty(opt) || isempty(opt.class))
	
	c = [];
	
else
	
	switch (opt.class)
		
		case ('double'), c = double([]);
			
		case ('single'), c = single([]);
			
		case ('int16'), c = int16([]);
			
		case ('int32'), c = int32([]);
			
		otherwise, error(['Unsupported sample type ''', opt.class, '''.']);
			
	end
	
end

%--
% get samples using mex
%--

X = sound_read_(str,ix,n,int16(ch),c)'; % note the transpose

% X = X(:,ch);
