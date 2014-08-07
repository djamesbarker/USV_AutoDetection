function set_freq_grid(ax,opt,f)

% set_freq_grid - set frequency grid for spectrogram display axes
% ---------------------------------------------------------------
% 
% set_time_grid(ax,opt,f)
%
% Input:
% ------
%  ax - axes to set
%  opt - grid options
%  f - frequency limits (in current units)

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
% $Revision: 819 $
% $Date: 2005-03-27 15:06:08 -0500 (Sun, 27 Mar 2005) $
%--------------------------------

%--------------------------------------------------------
% HANDLE INPUT
%--------------------------------------------------------

%--
% get and check frequency limits if needed
%--

if ((nargin < 3) || isempty(f))
	
	%--
	% get frequency limits
	%--

	f = get(ax(1),'ylim');

	%--
	% check that axes have same frequency limits if needed
	%--

	if (length(ax) > 1)

		for k = 2:length(ax)
			
			if (~isequal(t,get(ax(k),'ylim')))
				disp(' ');
				error('Input axes must have shared ''ylim'' property.');
			end 
			
		end

	end
	
end

%--------------------------------------------------------
% SET FREQUENCY GRID SPACING
%--------------------------------------------------------

%--
% specified grid spacing
%--

if (~isempty(opt.freq.spacing))

	%--
	% consider kHz display
	%--
	
	% NOTE: the spacing is always described in hertz
	
	if (strcmp(opt.freq.labels,'kHz'))
		opt.freq.spacing = opt.freq.spacing / 1000;
	end

	%--
	% compute ticks according to spacing
	%--

	% NOTE: this ensures an anchored grid
	
	n = f / opt.freq.spacing;

	ix = (ceil(n(1)):floor(n(2))) * opt.freq.spacing;

	%--
	% update ticks and labels if there are any
	%--
	
	if (~isempty(ix))
		
		%--
		% set ticks
		%--

		set(ax,'ytick',ix);

		%--
		% compute yticklabels
		%--

		for k = 1:length(ix)
			str{k} = num2str(ix(k),3);
		end

		str = decimate_labels(str); % decimate labels to reduce clutter

		%--
		% set axes yticklabels
		%--

		% NOTE: this loop may not be needed

		for k = 1:length(ax)
			set(ax(k),'yticklabel',str);
		end
		
	end

%--
% automatic frequency grid
%--

else

	%--
	% reset automatic placing and labelling of frequency axis
	%--

	set(ax, ...
		'ytick',[], ...
		'yticklabel',[], ...
		'ytickmode','auto', ...
		'yticklabelmode','auto' ...
	);

end

%--------------------------------------------------------
% SET FREQUENCY GRID DISPLAY
%--------------------------------------------------------

% FIXME: there are problems displaying this in the selection zoom

if (opt.on && opt.freq.on)
	set(ax,'ygrid','on');	
else
	set(ax,'ygrid','off');	
end

%--------------------------------------------------------
% SET FREQUENCY GRID COLOR
%--------------------------------------------------------

set(ax,'ycolor',opt.color);
		
