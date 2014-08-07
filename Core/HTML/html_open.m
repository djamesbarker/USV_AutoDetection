function html_open(fid, title, style)

% html_open - output header for html file
% ---------------------------------------
%
% html_open(fid, title, style)
%
% Input:
% ------
%  fid - output file identifier
%  title - document title
%  style - style file to include

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
% $Revision: 2014 $
% $Date: 2005-10-25 17:43:52 -0400 (Tue, 25 Oct 2005) $
%--------------------------------

% TODO: add keywords and description

% TODO: consider stylesheets as well as style text

%---------------------------
% HANDLE INPUT
%---------------------------

%--
% handle style input
%--

% NOTE: when the input style file is not available we get empty string

if nargin < 2
	style = '';
else
	style = which(style);
end

%--
% pack template data if available
%--

if ~isempty(title)
	data.title = title;
end

if ~isempty(style)
	data.style = style;
end

%--
% process template
%--

% NOTE: template processing removes markup when it does not find variables

if ~exist('data', 'var')
	html_template(fid, 'html_open.html');
else
	html_template(fid, 'html_open.html', data);
end
