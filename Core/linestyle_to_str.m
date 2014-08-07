function  [lt,S] = linestyle_to_str(str,opt)

% linestyle_to_str - linestyle string for named linestyle
% -------------------------------------------------------
%
% [lt,S] = linestyle_to_str(str,opt)
%
% Input:
% ------
%  str - linestyle name
%  opt - linestyle set option 'strict' or 'loose' (def: 'loose')
%
% Output:
% -------
%  lt - linestyle string
%  S - menu separators

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
% set linestyle set option
%--

if ((nargin < 2) | isempty(opt))
	opt = 'loose';
else
	ix = find(strcmp(opt,{'strict','loose'}));
	if (isempty(ix))
		disp(' ');
		error('Unrecognized linestyle set option.');
	end
end

%--
% create name color cell array table
%--

% loose interpretation of linestyle, may lead to warning

if (strcmp(opt,'loose'))
	
	T = { ...
		'Solid','-'; ...
		'Dash','--'; ...
		'Dash-Dot','-.'; ...
		'Dot',':'; ...
		'Cross','x'; ...
		'Plus','+'; ...
		'Star','*'; ...
		'Circle','o';...
		'Diamond','d'; ...
		'Square','s'; ...
		'Triangle (Down)','v'; ...
		'Triangle (Up)','^'; ...
		'Triangle (Left)','<' ...
	};

% strict intepreration of linestyle

else
	
	T = { ...
		'Solid','-'; ...
		'Dash','--'; ...
		'Dash-Dot','-.'; ...
		'Dot',':' ...
	};
	
end

if (nargin & ~isempty(str))
	
	%--
	% look up linestyle
	%--
	
	ix = find(strcmp(str,T(:,1)));
	
	if (~isempty(ix))
		lt = T{ix,2};
	else
		lt = [];
	end
	
else
	
	%--
	% output all available linestyles 
	%--
	
	lt = T(:,1);
	
	%--
	% output menu separators
	%--
	
	if (nargout > 1)
		if (strcmp(opt,'loose'))
			n = length(lt);
			S = bin2str(zeros(1,n));
			S{5} = 'on';
			S{8} = 'on';
		else
			n = length(lt);
			S = bin2str(zeros(1,n));
		end
	end
	
end

