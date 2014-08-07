function out = extension_update(pal,in)

% extension_update - update state of extension using palette
% ----------------------------------------------------------
%
% out = extension_update(pal)
%     = extension_update(pal,in)
%
% Input:
% ------
%  pal - extension palette
%  in - extension to update (def: try to get extension from palette)
%
% Output:
% -------
%  out - updated extension

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

%-----------------------------------------------------
% HANDLE INPUT
%-----------------------------------------------------

%--
% get extension from palette name
%--

% NOTE: we can do this because we are about to update the extension state


%-----------------------------------------------------
% UPDATE EXTENSION
%-----------------------------------------------------

%--
% get extension palette control values and extension parameter values
%--

[param,values] = get_parameter_values(pal,in);

%--
% copy extension and update
%--

out = in; 

out.values = values;

out.parameter = param;
