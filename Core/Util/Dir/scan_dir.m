function out = scan_dir(p, fun, r, verb)

% scan_dir - directory scan with callbacks
% ----------------------------------------
%
% out = scan_dir(p, fun, r)
%
% Input:
% ------
%  p - scan start directory (def: pwd)
%  fun - directory callback function (def: store scan directories)
%  r - recursive scan flag (def: 1)
%
% Output:
% -------
%  out - results of scan
%
% NOTE: check code to understand callback function signature

% TODO: use two callbacks one for directories and one for files

%-------------------------------------------------
% SET PERSISTENT VARIABLES
%-------------------------------------------------

% TODO: eventually make these an input

%-- 
% create list of folders to exclude in recursive search
%--

persistent EXCLUDE_PATH EXCLUDE_NAME;

if isempty(EXCLUDE_PATH)
	
	EXCLUDE_PATH = { ...
		'C:\WINDOWS', ...
		'C:\Program Files', ...
		'C:\I386' ...
	};

	EXCLUDE_NAME = { ...
		'.', ...
		'..', ...
		'.svn' ...
		'__XBAT' ...
	};
end

%-------------------------------------------------
% HANDLE INPUT
%-------------------------------------------------

%--
% set verbosity
%--

% TODO: develop an environment level flag for this kind of work

if nargin < 4
	verb = 0;
end

%--
% set recursive flag
%--

if (nargin < 3) || isempty(r)
	r = 1;
end

%--
% set default callback fun
%--

% NOTE: the default function simply stores the paths BFS order

if (nargin < 2) || isempty(fun)
	fun = @store_path;
end

%--
% set starting directory
%--

if (nargin < 1) || isempty(p)
	p = pwd;
end

% NOTE: remove trailing filesep if needed

if p(end) == filesep
	p(end) = [];
end

%-------------------------------------------------
% RECURSIVE SEARCH
%-------------------------------------------------

if r
	
	%--
	% check for excluded directory
	%--
			
	% TODO: this is not excluding at the right level, consider removing
	
	if ( ...
		~isempty(find(strcmp(p, EXCLUDE_PATH), 1)) || ...
		~isempty(find(strcmp(file_parent(p), EXCLUDE_NAME), 1)) ...
	)		
		out = []; return;
	end
	
	%--
	% create output from current directory with non-recursive call
	%--

	d = p;

	out = scan_dir(d, fun, 0, verb);
		
	%--
	% this is a generic 'verb' display for this function
	%--
	
	% NOTE: the semantics of empty are general here, not according to callback
	
	if verb && ~isempty(out)
		%--
		% display directory being scanned
		%--
		
		str = ['SCAN DIR: ', d];
		
		disp(' ');
		str_line(length(str));
		disp(str);
		str_line(length(str));
		
		%--
		% display results of scan
		%--
				
		disp(' ');
		disp(sprintf(to_xml(out)));
	end
	
	if ischar(out)
		out = {out};
	end
	
	%--
	% add outputs from children directories recursively
	%--
		
	% NOTE: the concatenation produces column arrays
	
	ch = what_ext(p);
	
	if ~isempty(ch.dir)
		
		%--
		% loop over children directories
		%--
		
		for k = 1:length(ch.dir)
			
			%--
			% perform name and path exclusion here
			%--
			
			if ~isempty(find(strcmpi(ch.dir{k}, EXCLUDE_NAME), 1))
				continue;
			end

			d = [p, filesep, ch.dir{k}];
			
			if ~isempty(find(strcmpi(d, EXCLUDE_PATH), 1))
				continue;
			end
			
			%--
			% create or append out array
			%--
			
			if isempty(out)
				out = scan_dir(d, fun, 1, verb);
				
				if ischar(out)
					out = {out}; 
				end
			else
				new = scan_dir(d, fun, 1, verb);
				
				if isempty(new)
					continue;
				end 
				
				switch class(new)
					
					% NOTE: this is used in the default callback 'store_path'
					
					case {'char', 'cell'}
						out = [out(:); new(:)];
						
					% NOTE: this is the type of output used in related functions
					
					case 'struct'
						out = [out(:); new(:)];
						
					% NOTE: it is not clear how to simply support other classes
					
					otherwise
						error('Callback output must be of ''char'' or ''struct'' class.');	
				end
			end
		end
	end
		
	return;
end

%-------------------------------------------------
% EXECUTE DIRECTORY CALLBACK
%-------------------------------------------------

% NOTE: callback function input is a function handle or a cell array

if iscell(fun)
	% NOTE: the first cell is the handle the rest are arguments following path
	
	out = fun{1}(p, fun{2:end}); 
else
	out = fun(p); 
end


%-------------------------------------------------
% STORE_PATH
%-------------------------------------------------

function out = store_path(p)

% store_path - simply returns the path as output
% ----------------------------------------------

out = p;
