function generate_function(ext, fun)

% generate_function - generate template function for extension
% ------------------------------------------------------------
%
% generate_function(ext, fun)
%
% Input:
% ------
%  ext - extension to generate function for
%  fun - name of function to generate
%
% Output
% ------
%  flag - success flag

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

% TODO: generate null or identity compute as default to make extensions 'able'

%-----------------------------------
% HANDLE INPUT
%-----------------------------------

%--
% get interface information for extension type
%--

type = ext.subtype;

[name, args, sig, out] = extension_signatures(type);

%--
% set default functions to generate
%--

% NOTE: the default is to generate all

if nargin < 2
	fun = name;
end

% NOTE: return if there is nothing to generate

if isempty(fun)
	return;
end

% NOTE: wrap fun string in cell

if ischar(fun)
	fun = {fun};
end

%-----------------------------------
% GENERATE FUNCTIONS
%-----------------------------------

root = extension_root(ext);

%--
% loop over requested functions
%--

for k = 1:length(fun)
	
	%--
	% find function in interface
	%--
	
	ix = find(strcmp(name, fun{k}));
	
	if isempty(ix)
		continue;
	end
	
	%--
	% check for file, continue if it exists, create if needed
	%--
	
	f = [root, filesep, 'private', filesep, name{ix}, '.m'];
	
	% TODO: ask if we want to regenerate file
	
	if exist(f, 'file')
		continue;
	end
	
	fid = fopen(f, 'w'); rel_path(f);
	
	%-- 
	% add function signature and indicator comment
	%--
	
	fprintf(fid, '%s\n\n%s\n\n', ...
		['function ', sig{ix}], ...
		['% ', upper(ext.name), ' - ', name{ix}] ...
	);

	%--
	% add trivial body to make function execute
	%--
	
	if isempty(ext.parent)
		
		fprintf(fid, '%s\n', out{ix});
	
	else
		
		par = ext.parent.main();
		
		par_fun = flatten(par.fun);
		
		% NOTE: if possible create code to evaluate parent function
		
		if isfield(par_fun, name{ix}) && ~isempty(par_fun.(name{ix}))
			
			fprintf(fid, '%s\n\n%s; %s;\n', ...
				['% ', out{ix}], ...
				'fun = parent_fun', strrep(sig{ix}, name{ix}, 'fun') ...
			);
		
		else
			
			fprintf(fid, '%s\n', out{ix});
		
		end
		
	end
	
	%--
	% create skeleton control and callback code
	%--
	
	% NOTE: do not try to make this code too smart, it will just make it ungraceful
	
	%--
	% close file
	%--
	
	fclose(fid);
	
end
