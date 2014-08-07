function logL = betalik1(params,ld,l1d,n)
%BETALIK1 is a helper function. It is the same as BETALIKE, except it
% directly computes the betapdf without calling BETAPDF, also, saved some
% error checking and size checking.

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

%   ZP You 3-8-99
%   Copyright 1993-2000 The MathWorks, Inc. 
%   $Revision: 1.0 $  $Date: 2003-09-16 01:32:08-04 $

a = max(params(1),0);
b = max(params(2),0);

logL = n*betaln(a,b)+(1-a)*ld+(1-b)*l1d;


