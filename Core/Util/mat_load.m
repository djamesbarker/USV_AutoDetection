function [out,fail] = mat_load(in,varargin)

% mat_load - load variables from mat file
% ---------------------------------------
%
% [out,fail] = mat_load(in,'var_1', ... ,'var_n')
%
% Input:
% ------
%  in - file location
%  var_k - variable name description
%
% Output:
% -------
%  out - variable structure

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
% $Revision: 2196 $
% $Date: 2005-12-02 18:16:46 -0500 (Fri, 02 Dec 2005) $
%--------------------------------

% NOTE: we use this function to ignore file name and to wrap load and catch warnings

%--
% simple load
%--

names = varargin;

if (length(names) < 1)
	
	out = load('-mat',in);
	
%--
% load variables
%--

else
	
	%--
	% inspect for requested variables
	%--
	
	var = mat_inspect(in,names{:});
		
	%--
	% check for load failure and remove missing variables from load
	%--
	
	if (isempty(var))
		out = []; return;
	end
		
	found = names;
	
	for k = length(found):-1:1
		if (isempty(var.(names{k})))
			found(k) = [];
		end
	end
	
	fail = setdiff(names,found);
	
	%--
	% load found variables
	%--
	
	out = load('-mat',in,found{:});
	
end
