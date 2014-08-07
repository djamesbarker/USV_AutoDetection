function sound = sound_update(sound, data)

% sound_update - update view fields of sound using browser structure
% ------------------------------------------------------------------
%
% sound = sound_update(sound, data)
%
% Input:
% ------
%  sound - sound structure
%  data - browser figure structure
%
% Output:
% -------
%  sound - updated sound structure

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
% $Revision: 6221 $
% $Date: 2006-08-18 12:25:48 -0400 (Fri, 18 Aug 2006) $
%--------------------------------

% TODO: rename to sound_view_update

% NOTE: this function is temporary. keeping two copies of these fields is redundant

%--
% update view fields
%--

sound.view.channels = data.browser.channels;

sound.view.time = data.browser.time;

sound.view.page = data.browser.page;

sound.view.grid = data.browser.grid;

sound.view.colormap = data.browser.colormap;

%--
% update spectrogram computation fields
%--

sound.specgram = data.browser.specgram;

%--
% update modification date
%--

sound.modified = now;
