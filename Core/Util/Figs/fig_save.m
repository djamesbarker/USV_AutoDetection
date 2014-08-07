function fig_save(h,p)

% fig_save - save figure as fig file
% ----------------------------------
%
% fig_save(h,p)
%
% Input:
% ------
%  h - handle to figure
%  p - filename or path

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
% $Revision: 1.0 $
% $Date: 2003-09-16 01:30:43-04 $
%--------------------------------

%--
% set figure
%--

if (nargin < 1)
	h = gcf;
end

%--
% set filename
%--

if (nargin < 2)
	p = fig_name(h)
end

if (isempty(p))
	disp(' ');
	error('Figure is not a proper fig, it does not have a name.');
end

%--
% set extension on filename
%--

p = file_ext(p,'fig');

% HGSAVE  Saves an HG object hierarchy to a MAT file.
% 
% HGSAVE(H, 'Filename') saves the objects identified by handle array H
% to a file named 'Filename'.  If 'Filename' contains no extension,
% then the extension '.fig' is added.  If H is a vector, none of the
% handles in H may be ancestors or descendents of any other handles in
% H.
%
% HGSAVE('Filename') saves the current figure to a file named
% 'Filename'.
%
% HGSAVE(..., 'all') overrides the default behavior of excluding
% non-serializable objects from the file.  Items such as the default
% toolbars and default menus are marked as non-serializable, and are
% normally not saved in FIG-files, because they are loaded from
% separate files at figure creation time.  This allows the size of
% FIG-files to be reduced, and allows for revisioning of the default
% menus and toolbars without affecting existing FIG-files. Passing
% 'all' to HGSAVE insures non-serialzable objects are also saved.
% Note: the default behavior of HGLOAD is to ignore non-serializable
% objects in the file at load time, and that can be overridden using
% the 'all' flag with HGLOAD.
%
% See also HGLOAD.
%

%   Copyright 1984-2001 The MathWorks, Inc. 
%   $Revision: 1.0 $  $Date: 2003-09-16 01:30:43-04 $
%   D. Foti  11/10/97

% error(nargchk(1, inf, nargin));
% 
% % pull off handle + 'filename,' or just 'filename'
% if(isstr(varargin{1}))
%   h = gcf;
%   filename = varargin{1};
%   first_pass_through = 2;
% else
%   h = varargin{1};
%   if any(~ishandle(h))
%     error('Invalid handle');
%   end
%   filename = varargin{2};
%   first_pass_through = 3;
% end
% 
% [path, file, ext] = fileparts(filename)

% fileparts returns everything from the last . to the end of the
% string as the extention so the following test will catch
% an extention with 0, 1, or infinity dots.
% for example, all these filenames will have .fig added to the end:
%  foo.
%  foo..
%  foo.bar.
%  foo.bar...

% if isempty(ext) | strcmp(ext, '.')
%   filename = fullfile(path, [file , ext, '.fig'])
% end

% Revision encoded as 2 digits for major revision,
% 2 digits for minor revision, and 2 digits for
% patch revision.  This is the minimum revision 
% required to fully support the file format.
% e.g. 050200 means 5.2.0

% if saving a figure and plotedit, zoom or rotate3d
% are on, save their states and
% turn them off before saving
% and if scribe clear mode callback appdata
% exists, remove it.

plotediton = zeros(length(h),1);
rotate3dstate = cell(length(h),1);
zoomstate = cell(length(h),1);
scmcb = cell(length(h),1);

for i = 1:length(h)
  if strcmp(get(h(i), 'type'), 'figure')
    plotediton(i) = plotedit(h(i), 'isactive');
    rotate3dstate{i} = getappdata(h(i),'Rotate3dOnState');
    zoomstate{i} = getappdata(h(i),'ZoomOnState');
    s = getappdata(h(i),'ScribeClearModeCallback');
    if ~isempty(s) & iscell(s)
        scmcb{i} = s;
        rmappdata(h(i),'ScribeClearModeCallback');
    end
    if plotediton(i)
        plotedit(h(i),'off');
    end
    if ~isempty(rotate3dstate{i})
        rotate3d(h(i),'off');
    end
    if ~isempty(zoomstate{i})
        zoom(h(i),'off');
    end
  end
end

% hgS_050200 = handle2struct(h, varargin{first_pass_through:end});

hgS_050200 = handle2struct(h);

% restore plotedit, zoom and rotate3d states if saving a figure
for i = 1:length(h)
    if strcmp(get(h(i),'type'),'figure')
        % if plotedit was on, restore it
        if plotediton(i)
            plotedit(h(i),'on');
        end
        % if rotate3d was on, restore it
        if ~isempty(rotate3dstate{i})
            rotate3d(h(i),rotate3dstate{i});
        end
        % if zoom was on, restore it
        if ~isempty(zoomstate{i})
            zoom(h(i),zoomstate{i});
        end
        % if there was a scribeclearmodecallback, reset it
        if ~isempty(scmcb{i})
            setappdata(h(i),'ScribeClearModeCallback',scmcb{i});
        end   
    end
end

save(p,'hgS_050200');


