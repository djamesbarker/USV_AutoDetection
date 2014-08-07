function out = extension_description_dialog(ext)

% extension_description_dialog - dialog for extension description edit
% --------------------------------------------------------------------
%
% out = extension_description_dialog(ext)
%
% Input:
% ------
%  ext - extension to edit
%
% Output:
% -------
%  out - dialog results

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

% NOTE: the extensions required should be a text that gets fed from popup

%----------------------------------
% CREATE DIALOG CONTROLS
%----------------------------------

% TODO: solve the problem of getting extension information into the dialog

% NOTE: we can inject extension information in the description file, description, or controls

% file = [tempname, '.xdf'];

control = generate_description_controls('extension_description.xdf');

%----------------------------------
% CREATE DIALOG
%----------------------------------

% NOTE: make the description header non-collapsible'

control(1).min = 1;

%--
% configure dialog options
%--

opt = dialog_group;

opt.width = 14;

opt.header_color = get_extension_color(ext);

%--
% create dialog
%--

% name = [ext.name, ' Description'];

name = 'Edit ...';

out = dialog_group(name, control, opt, @dialog_callback);

% TODO: consider handling values to update extension through merge


%-------------------------------------
% DIALOG_CALLBACK
%-------------------------------------

function dialog_callback(obj, eventdata);

% NOTE: this is useful when developing, it wraps 'get_callback_context' and 'control_update'

call = control_callback_tracer(obj);

	
