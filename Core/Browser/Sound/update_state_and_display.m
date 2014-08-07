function update_state_and_display(par, data)

%----------------------------
% HANDLE INPUT
%----------------------------

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

if nargin < 2
	data = get_browser(par);
end

%----------------------------
% UPDATE STATE
%----------------------------
	
%--
% get current channels state
%--

current = get_browser(par, 'channels');

%--
% adapt spectrogram parameters
%--

% NOTE: this updates the spectrogram palette

% NOTE: channels may have been updated in state, but not yet in display!

data = update_specgram_param(par, data, 1);

%--
% check if we need channel update
%--

if ~isequal(current, data.browser.channels)
	browser_view_menu(par, 'Update Channels');
end

%--
% perform scrollbar update
%--

browser_view_menu(par, 'scrollbar');


