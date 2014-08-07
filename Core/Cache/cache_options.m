function opt = cache_options(opt)

% cache_options - set and get cache options
% -----------------------------------------
%
% opt = cache_options(opt)
% 
% Input:
% ------
%  opt - cache options
%
%    .mode - cache creation mode 'off', 'on', or 'network' (def: 'network')
%    .size - size of cache in kilobytes (def: 16384)
%
% Output:
% -------
%  opt - cache options

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
% $Revision: 132 $
% $Date: 2004-12-02 15:58:47 -0500 (Thu, 02 Dec 2004) $
%--------------------------------

%--
% get cache options, set default options if needed
%--

if (~nargin)
	
	data = get(0,'userdata');
	
	%--
	% get cache options
	%--
	
	if (isfield(data,'cache_options'))
		
		opt = data.cache_options;
	
	%--
	% set default cache options
	%--
	
	else

		data.cache_options.mode = 'off';
		
		data.cache_options.size = 16384; % = 16*1024
		
		set(0,'userdata',data);
		
		opt = data.cache_options;
		
	end
	
%--
% set cache options
%--

else
	
	%--
	% try to set cache options
	%--
	
	try
		
		%--
		% check provided options
		%--
		
		if (~any(strcmp(opt.mode,{'off','on','network'})))
			disp(' ');
			error('Cache option ''mode'' must be ''off'', ''on'', or ''network''.');
		end
		
		if (opt.size < 512)
			disp(' ');
			error('Cache options ''size'' must be larger than 4096 kilobytes.');
		end
		
		%--
		% set cache options
		%--
		
		data = get(0,'userdata'); 
		
		data.cache_options.mode = opt.mode;
		
		data.cache_options.size = opt.size;
		
		set(0,'userdata',data);
	
	%--
	% improper input
	%--
	
	catch 
		
		disp(' ');
		error('Input does not contain required cache option fields or improper values.');
		
	end
		
end
