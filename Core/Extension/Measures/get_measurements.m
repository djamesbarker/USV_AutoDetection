function [exts, names] = get_measurements(par, mode)

% get_measurements - get currently available measures
% -----------------------------------------------
%
% [exts, names] = get_measurements(par)
%
% Input:
% ------
%  par - browser handle (def: [])
%
% Output:
% -------
%  exts - measure 'extensions'
%  names - measure names

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

% NOTE: 'mode' input is ignored, but kept momentarily for backwards compatibility

%--
% set handle
%--

if nargin < 1
	par = [];
end

%--
% get functions in measures directory
%--

fun = what([extensions_root, filesep, 'Measures']); 

fun = what([fun.path, filesep, 'Event']);

fun = unique(file_ext({fun.m{:}, fun.p{:}}));

%--
% get measure extensions
%--

exts = [];

for k = 1:length(fun)

	%--
	% skip non-extension files
	%--
	
	if ~findstr(fun{k}, '_measure')
		continue;
	end

	%--
	% try to get extension
	%--
	
	% NOTE: this handles extensions that fail to load altogether
	
	try
		
		ext = feval(file_ext(fun{k}), 'create', par);
	
	catch
		
		% NOTE: eventually we will just use extension warning
		
		if 0
			
			disp(' ');
			disp(['WARNING: Failed to load measurement from ''', file_ext(fun{k}), '''.']);
			disp(' ');

			info = lasterror;

			% NOTE: apparently the stack information is not available in 7.0.1

			if ~isfield(info, 'stack')
				info.stack = {'No stack information available.'};
			end

			info.stack = info.stack(1); xml_disp(info);
		
		end
		
		continue;
	
	end

	%--
	% add extension to list
	%--
	
	% NOTE: the exception here handles variations in extensions structure
	
	if isempty(exts)
		exts = ext;
	else
		try
			exts(end + 1) = ext;
		catch
			continue;
		end
	end

end

%--
% get measure names
%--

names = {exts.name};

