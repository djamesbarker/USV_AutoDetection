function [call,value] = control_callback_tracer(obj)

% control_callback_tracer - utility function for callback development
% -------------------------------------------------------------------
%
% [call,value] = control_callback_tracer(obj)
%
% Input:
% ------
%  obj - callback object handle
%
% Output:
% -------
%  call - packed callback context
%  value - control value

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
% $Revision: 1380 $
% $Date: 2005-07-27 18:37:56 -0400 (Wed, 27 Jul 2005) $
%--------------------------------

%---------------------------------
% GATHER INFORMATION
%---------------------------------

%--
% get callback context
%--

call = get_callback_context(obj,'pack');

%--
% get callback control value
%--

[ignore,value] = control_update([],call.pal.handle,call.control.name);

%---------------------------------
% DISPLAY INFORMATION
%---------------------------------

% TODO: improve display

str = '';

if (~isempty(call.par.handle))
	str = ['PAR: ', call.par.name, ', '];
end

str = [str, 'PAL: ', call.pal.name, ', CONTROL: ', call.control.name];

disp(' ');
disp(str);
disp(str_line(str))

xml_disp(value);
