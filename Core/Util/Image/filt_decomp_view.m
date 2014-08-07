function filt_decomp_view(F)

% filt_decomp_view - interface to view filter decomposition
% ---------------------------------------------------------
%
% filt_decomp_view(F)
%
% Input:
% ------
%  F - filter decomposition

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
% $Revision: 132 $
% $Date: 2004-12-02 15:58:47 -0500 (Thu, 02 Dec 2004) $
%--------------------------------

%--
% create display of filter decomposition
%--

%--
% create controls for display
%--

%--------------------------------------------
% FILT_DECOMP_DISPLAY
%--------------------------------------------

% filt_decomp_display - create filter decomposition display
% ---------------------------------------------------------
%
% filt_decomp_controls(h,F)
%
% Input:
% ------
%  h - parent display figure
%  F - filter decomposition
%  opt - display options

%--
% create display
%--

if (isempty(h))
	
	%--
	% create and tag figure and axes 
	%--
	
	h = fig;
	set(f,'tag','FILT_DECOMP_FIG');
	
	ax = axes;
	set(ax,'tag','FILT_DECOMP_AXES');
	
	%--
	% display filter
	%--
	
	axes(ax);
	imagesc(filt_synth(F,opt.rank));
	
%--
% update display
%--

else
	
	%--
	% get axes
	%--
	
	ax = findobj(h,'tag','FILT_DECOMP_AXES');
	
	%--
	% update filter display
	%--
	
	axes(ax);
	imagesc(filt_synth(F,opt.rank));
	
end

%--------------------------------------------
% FILT_DECOMP_CONTROLS
%--------------------------------------------

function filt_decomp_controls(F)

% filt_decomp_controls - controls for filter decomposition display
% ----------------------------------------------------------------
%
% filt_decomp_controls(F)
%
% Input:
% ------
%  F - filter decomposition

%--
% create control array
%--

%--
% create palette
%--

%--------------------------------------------
% FILT_DECOMP_CALLBACKS
%--------------------------------------------

function filt_decomp_callbacks(obj,eventdata)

% filt_decomp_callbacks - callbacks for filter decomposition display
% ------------------------------------------------------------------
%
% filt_decomp_callbacks(obj,eventdata)
%
% Input:
% ------
%  obj - callback control handle
%  eventdata - unused at the moment

%--
% get control name
%--

%--
% update display accordingly
%--




