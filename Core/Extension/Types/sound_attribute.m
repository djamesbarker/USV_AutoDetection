function fun = sound_attribute

% NOTE: consider reuse of the 'param_fun' api structure, attributes are
% sort of parameters, susceptible to: creation, compilation, and control,
% the controls can take options and have a callback that represents the
% attribute model. What is the relation between preset store and load with
% read and write?

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

% NOTE: the context will contain the sound, which will probably provide
% some indication of where the file is and help to validate its contents

% NOTE: it is not clear that we need to specify the file, sort of like
% presets where we don't need to specify the location only the name, except
% in this case we may not even need a name

fun = param_fun('attribute');

