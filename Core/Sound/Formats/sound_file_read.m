function [X, r] = sound_file_read(f, ix, n, N, ch, opt)

% sound_file_read - read samples from sound file
% ----------------------------------------------
%
% [X, r] = sound_file_read(f, ix, n, N, ch, opt)
%
% opt = sound_file_read
%
% Input:
% ------
%  f - file name or info
%  ix - initial sample
%  n - number of samples
%  N - total samples in file
%  ch - channels to select
%  opt - conversion options
%
% Output:
% -------
%  X - samples from sound file
%  r - sample rate
%  opt - default conversion options

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

%--
% output default conversion options structure
%--

if ~nargin
	opt.rate = []; opt.class = []; X = opt; return;
end

%--
% check for file info
%--

switch class(f)
	
	% create fake info struct with file name
	
	case 'char', info = info_create; info.file = f;
	
	% input is file info structure
	
	case 'struct'
		
		if ~isfield(f, 'file')
			error('Input file struct does not have ''file'' field.');
		end
		
		info = f; f = info.file;
		
	% error
	
	otherwise, error('Input must be a file name or info struct.');
		
end
	
%------------------------------------------------------
% OUTPUT ZEROS FOR MISSING FILE
%------------------------------------------------------

% TODO: handle request for rate in this case

if ~exist(f, 'file')
	
	%--
	% see if we have information to output zeros
	%--

	% NOTE: in this case the file is unavailable and we can't generate zeros

	if ( ...
		~exist('ch', 'var') || ~exist('n', 'var') || ...
		isempty(ch) || isempty(n) ...
	)
		error('File is unavailable and read specification input is insufficient.');
		
	end

	%--
	% output zeros
	%--
	
	% NOTE: this is a non-disruptive way of handling missing files
	
	X = zeros(n, length(ch));
	
	%--
	% produce visible warning of zeros
	%--
	
	% NOTE: we don't use the builtin warning because it is slow
	
	disp(' ');
	disp(['WARNING: Reading samples from ''' f ''' failed.']);
	disp(['File is not available, padding with zeros']);
	
	return;
	
end

%------------------------------------------------------
% HANDLE INPUT
%------------------------------------------------------

%--
% set default modification options
%--

% NOTE: use simple empty for no conversion options

if nargin < 6
	opt = [];
end

%--
% set default channels if none given
%--

if nargin < 5
	ch = [];
end

%--
% set total samples in file if needed
%--

if (nargin < 4) || isempty(N)
	
	if isempty(info.samples)
		info = sound_file_info(f); 
	end

	N = info.samples;

end

%--
% set default start and duration if needed
%--

if (nargin < 2) || isempty(ix)
	ix = 0;
end

if (nargin < 3) || isempty(n)	
	n = N - ix;
else	
	if (ix + n) > N
		error('Required samples exceed end of sound file.');
	end
end

%------------------------------------------------------
% READ SAMPLES FROM FILE
%------------------------------------------------------

%--
% try to get format handler
%--

format = get_file_format(f);

%--
% read file using handler
%--

[X, opt] = format.read(info, ix, n, ch, opt);

%------------------------------------------------------
% GET SAMPLERATE
%------------------------------------------------------

%--
% get samplerate from file info if needed
%--

% NOTE: we get this if output is requested or we need it for resample

if (nargout > 1) || (~isempty(opt) && ~isempty(opt.rate))
	
	%--
	% get file rate
	%--
	
	% NOTE: we may have file info already if total samples were not input
	
	if ~exist('info', 'var') || isempty(info.samplerate)
		info = sound_file_info(f);
	end
	
	r_file = info.samplerate;
	
	%--
	% return output rate
	%--
	
	% NOTE: return converted rate if conversion was peformed
	
	if isempty(opt)
		r = r_file;
	else
		r = opt.rate;
	end
	
end

%------------------------------------------------------
% HANDLE REMAINING CONVERSION REQUESTS
%------------------------------------------------------

% NOTE: we think of the options fields as conversion requests

if ~isempty(opt)
	
	%--
	% resample to conversion rate
	%--
	
	if ~isempty(opt.rate)
		
		% NOTE: compute rational approximation to resampling ratio and resample
		
		ratio = opt.rate / r_file; [p, q] = rat(ratio); X = resample(X, p, q);

	end
	
	%--
	% cast to conversion class
	%--
	
	if ~isempty(opt.class)
		
		% NOTE: create and apply class casting function handle
		
		fun = str2func(opt.class); X = fun(X);
		
	end
	
end
