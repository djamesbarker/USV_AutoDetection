function pointer = find_file(name, path, varargin)
	
if nargin < 2
    path = pwd;
end

if nargin < 1
    name = '*.*';
end

dir = 0; abs = 0; all = 0;

here = pwd;

%--
% handle input arguments
%--

for ix = 1:length(varargin)

	arg = varargin{ix};
	
	if (arg(1) == '-')
		
		switch (arg(2))
			
			case ('d')
				dir = 1;
				
			case ('a')
				all = 1;
				
			case ('p')
				abs = 1;
				
		end
		
	end
	
end

%--
% call recursive search function
%--

if (abs)
	cd(path);
	path = pwd;
	cd(here);
end

if ~length(varargin)
	dir = 0;
	all = 0;
end

% pointer = find_file_rec(name, path, dir, all);

pointer = scan_dir(path, {@match, name, dir, all});


%-------------------------------------
% MATCH
%-------------------------------------

function out = match(path, name, d, all)

if (nargin < 3)
	all = 1;
end

out = cell(0);

%--
% loop over directory
%--

list = dir(path);

for ix = 1:length(list)
	
	if (any(strfind(list(ix).name, name)) && (~xor(d, list(ix).isdir)))
	
		%--
		% if there is a match as decided by strfind, concatenate
		%--
		
		out{end + 1} = [path, filesep, list(ix).name];
		
		if (~all)
			return
		end
	
	end
	
end

if (~length(out))
	out = [];
end
