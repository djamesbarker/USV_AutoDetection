function [ext, context] = get_extension(type, name, pal)

if nargin < 3
	pal = [];
end

ext = get_extensions(type, 'name', name);

context = [];

if isempty(ext)
	return;
end

%--
% pack context
%--

% GENERAL FIELDS

context.ext = ext; 

context.user = get_active_user;

context.library = get_active_library;

sound = get_active_sound;

%--
% make a duck sound if necessary
%--

if isempty(sound)
	sound.output.rate = 10000;
end

context.sound = sound; 

%--
% get control values
%--

if ~isempty(pal)
	
	ext.control = get_control_values(pal);
	
	if isfield(ext.control, 'debug')
		context.debug = ext.control.debug;
	end
	
end

%--
% create extension parameters if needed
%--

if isfield(ext.fun.parameter, 'create') && ~isempty(ext.fun.parameter.create)

	try
		ext.parameter = ext.fun.parameter.create(context);
	catch
		extension_warning(ext, 'Parameter creation failed.', lasterror);
	end

end
		
if isempty(ext.parameter)
	return;
end

%--
% update extension parameters using palette and compile if needed
%--

if ~isempty(pal)
	
	% NOTE: update must be configured to be shallow
	
	opt = struct_update; opt.flatten = 0;
	
	ext.parameter = struct_update(ext.parameter, ext.control, opt);
	
end

if isfield(ext.fun.parameter, 'compile') && ~isempty(ext.fun.parameter.compile)
	
	try
		[ext.parameter, context] = ext.fun.parameter.compile(ext.parameter, context);
	catch
		extension_warning(ext, 'Parameter compilation failed.', lasterror);
	end

end

context.ext = ext;
