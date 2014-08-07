function build_all(location)

% build_all - find and compile all mex code in the XBAT project
% -------------------------------------------------------------

%--
% scan the xbat folder by default
%--

if ~nargin
    location = xbat_root;
end

%--
% scan the file system and build for each MEX directory
%--

scan_dir(location, {@build_cb, pwd});


%-----------------------------------
% BUILD_CB
%-----------------------------------

function result = build_cb(path, initialpath)

result = [];

if ~strcmp(path(end-2:end), 'MEX')
    return;
end

%--
% if it is a MEX directory, run build
%--

try
    cd(path); build; cd(initialpath);
catch 
    cd(initialpath);
end
 
