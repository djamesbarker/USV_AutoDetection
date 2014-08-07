function result = attribute_dispatch(obj, eventdata, ext, create)

% attribute_dispatch - attribute editing/creating gateway
% -------------------------------------------------------
%
% result = attribute_dispatch(obj, eventdata, ext, create)
%
% Input:
% ------
%  obj - object
%  eventdata - eventdata
%  ext - the attribute extension object
%  create - whether to create the attribute if it doesn't exist
%
% Output:
% -------
%  result - the result

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
% handle input and setup
%--

if nargin < 4 || isempty(create)
	create = 0;
end

result = []; attribute = [];

%--
% build context
%--

par = ancestor(obj, 'figure');

if is_browser(par)
	
	sound = get_browser(par, 'sound'); info = get_browser_info(par);
	
	lib = get_library_from_name(info.library);
	
else
	
	[sound, lib] = get_selected_sound;
	
end

% NOTE: nothing to do if no selection and we can't handle multiple sounds

if length(sound) ~= 1
	return;
end

context.sound = sound; context.library = lib;

%--
% get attribute file for sound and type
%--

% TODO: the existence of this file, this should have consequences!

[file, exists] = get_attribute_file(context, ext.name);

%--
% load attribute from file
%--

if exists && ~isempty(ext.fun.load)
	try
		attribute = ext.fun.load(file, context);
	catch
		extension_warning(ext, 'Load failed.', lasterror);	
	end
end

%--
% create attribute from scratch
%--

if isempty(attribute) || (~exists && create && ~isempty(ext.fun.create))
	try
		attribute = ext.fun.create(context);
	catch
		extension_warning(ext, 'Create failed.', lasterror);
	end
end

%--
% edit attribute with dialog
%--

context.attribute = attribute;

result = attribute_dialog(ext, context, ~exists);

if ~strcmp(result.action, 'ok')
	return;
end

%--
% extract edited attribute from dialog result
%--

% NOTE: this is used to extract complex attributes from an axes control fishbowl

if ~isfield(result.values, ext.name)
	attribute = result.values;
else
	attribute = result.values.(ext.name);
end

% TODO: consider whether a compilation step is needed, and how this relates to fishbowls

context.dialog_result = result.values;

%--
% save attribute to file
%--

if ~exists
    
    p = create_dir(fileparts(file));
    
    if isempty(p)
        warning(['Unable to create attributes directory for "', sound_name(sound), '".']);
    end
    
end
    
try
	ext.fun.save(attribute, file, context);
catch
	extension_warning(ext, 'Save failed.', lasterror);
end

xbat_palette('find_sounds');

%--
% update open sound
%---

[test, par] = sound_is_open(context.sound);

if test
	
	str = { ...
		'In order to change the sound attributes', ...
		'the sound must be closed and re-opened.', ...
		'Would you like XBAT to close and re-open', ...
		'the sound?' ...
	};

	result = quest_dialog(str, 'Reload Sound?');
	
	if ~strcmpi(result, 'Yes')
		return;
	end
	
	set_browser_sound(par, context.sound);

end
	
	

