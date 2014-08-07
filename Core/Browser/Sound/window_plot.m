function window_plot(h, pal, data)

% window_plot - create and update window display
% ----------------------------------------------
% 
% window_plot(h, pal, data)

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

%--
% get display axes handle
%--

handles = get_control(pal, 'Window_Plot', 'handles');

% NOTE: return quickly if controls is not there

if isempty(handles)
	return;
end

ax = handles.axes;

%--
% prepare display
%--

axes(ax); hold on;

delete(get(ax, 'children'));

%--
% compute window and shifted window
%--

padwin = get_window(data.browser.specgram);

nfft = data.browser.specgram.fft;

next = floor(data.browser.specgram.hop * nfft);

%------------------------

% NOTE: the commented line does not work on 7.6

p1 = zeros(next,1);

p2 = padwin(1:(nfft - next));

nextwin = [p1(:); p2(:)];

% nextwin = [zeros(next,1); padwin(1:(nfft - next),1)];

%------------------------

%--
% display window and shifted window
%--
	
tmp = plot(padwin,'k');

set(tmp,'linewidth',1);

hold on;

tmp = plot(nextwin, ':k');

tmp = plot([1, nfft], [0, 0], ':');

set(tmp,'color',0.5 * ones(1,3));

tmp = plot([1, nfft], [1, 1], ':');

set(tmp,'color',0.5 * ones(1,3));

set(ax, ...
	'xlim', [1, nfft], 'ylim', [-0.2, 1.2] ...
);
