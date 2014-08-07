function [X, name] = test_scatter_data(par)

%--------------------
% HANDLE INPUT
%--------------------

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

if ~is_browser(par)
	error('Input handle is not browser handle.');
end

%--------------------
% SETUP
%--------------------

%--
% get logs from browser
%--

data = get_browser(par);

log = data.browser.log(1);

%--------------------
% SCATTER
%--------------------
	
%--
% get basic event data
%--

time = reshape([log.event.time]', 2, [])'; 

freq = reshape([log.event.freq]', 2, [])' / 1000;

X(:,1) = time(:, 1);

X(:,2) = freq(:, 1);

X(:,3) = diff(time, 1, 2);

X(:,4) = diff(freq, 1, 2);

%--
% set names
%--

name = { ...
	'Time', 'Freq', 'Duration', 'Bandwidth' ...
};

% NOTE: remove time variable

X = X(:, 2:end); name = name(2:end);


%--
% create scatter matrix
%--

scatter_matrix(fig, X, name);
