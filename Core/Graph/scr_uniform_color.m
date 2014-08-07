%--
% get parameters
%--

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

P = {'Size of Random Image','Probability of Occupation','Dilation SE','Number of Neighbors'};
T = 'Connected Component Labelling';
NL = 1;
DEF = {'512','0.02','se_ball(4)','4'};
			
AN = input_dialog(P,T,NL,DEF);

n = eval(AN{1});
p = eval(AN{2});
SE = eval(AN{3});
nn = eval(AN{4});
