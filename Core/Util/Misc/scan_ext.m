function [out,D] = scan_ext(d,varargin)

% scan_ext - scan directories for files with given extensions
% -----------------------------------------------------------
%
% [out,D] = scan_ext(d,x1,...,xN)
%
% Input:
% ------
%  d - scan start directory (def: pwd)
%  x1,...,xN - file extensions (def: '')
%
% Output:
% -------
%  out - array of 'what_ext' structures
%  D - directories scanned

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

%---------------------------------------
% HANDLE INPUT
%---------------------------------------

%--
% set default scan start directory
%--

if ((nargin < 1) || isempty(d))
	d = pwd;
end

%---------------------------------------
% SCAN DIRECTORY
%---------------------------------------

% NOTE: scan the directory with 'what_ext' as a callback using input extensions

out = scan_dir(d,{@what_ext,varargin{:}},1,0);

%---------------------------------------
% OUTPUT SCANNED DIRECTORIES
%---------------------------------------

if (nargout > 1)
	D = {out.path}'; % note the transpose
end

%---------------------------------------
% PRUNE RESULTS
%---------------------------------------

if (length(varargin))
	
	%--
	% test the presence of files of each extension type in each scanned directory
	%--

	for k = 1:length(varargin)
		ix(:,k) = ~cellfun('isempty',{out.(varargin{k})})'; % note the transpose
	end

	%--
	% test for the presence of any type in each scanned directory
	%--

	ix = sum(ix,2);

	%--
	% remove directories with no files of the desired type and remove
	%--

	out(ix == 0) = [];
	
else
	
	% NOTE: there is no pruning when there are no extensions

% 	% NOTE: the semantics of the pruning code are strange in this case
% 	
% 	%--
% 	% test for the presence of children directories
% 	%--
% 	
% 	ix = ~cellfun('isempty',{out.dir})';
% 	
% 	%--
% 	% remove directories with no directory children
% 	%--
% 	
% 	out(ix == 0) = [];

end
