function active = get_active_extensions(varargin) 

active = get_active_extension(get_extension_types, varargin{:});
