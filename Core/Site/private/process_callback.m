function lines = process_callback(line, data, debug)

% PROCESS_CALLBACK callback to process file markup
%
% lines = process_callback(line, data, debug)

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

if nargin < 3
	debug = 0;
end

%--
% convert tabs to spaces
%--

% NOTE: this converts a tab to two spaces

line = strrep(line, char(9), '  ');

%--
% split line to find segments to process
%--

% [seg, process] = line_split(line, '<%.*%>');

[seg, process] = split_line(line, '<%', '%>');

if debug
	xml_disp(seg);
end

%--
% return quickly if no processing is needed
%--

if ~any(process)
	lines = line; return;
end

%--
% loop over segments processing if needed
%--
 
lines = cell(0); site = data.model.site;

for k = 1:length(seg)
	
	%--
	% no process segment
	%--
	
	if ~process(k)
		
		% NOTE: this handles an end of sentence punctuation typography problem
	
		if (k > 1) && process(k - 1)
			lines{end} = [lines{end}, seg{k}];
		else
			lines{end + 1} = seg{k}; 
		end
		
		continue;
		
	end
	
	%--
	% parse command tokens
	%--

	% NOTE: the command is space separated, consider comma separated
	
	tok = split_tok(strtrim(seg{k}(3:end - 2)));
	
	%--
	% switch on command
	%--
	
	switch tok{1}

		%--
		% links
		%--
		
		case 'link'
			
			%--
			% inject data
			%--
			
			% NOTE: the first two tokens cannot be injected
			
			for j = 3:length(tok)
				tok{j} = inject(tok{j}, data);
			end
			
			%--
			% get link info
			%--
			
			% NOTE: the data provides the context for the basic tokens
			
			page = data.page; 
			
			type = [tok{2}, 's']; name = tok{3};

			%--
			% find asset and link to it
			%--
			
			switch type

				% TODO: add some flexibility here, allow 'img', 'scr', 'sty'
				
				case {'images', 'scripts', 'styles'}
					
					out = asset_link(data, type, name, tok{4:end});

				case 'pages'
					
					% TODO: move this into page link
					
					target = get_page_by_name(data.model.pages, name);
					
					if isempty(target)
						out = file_readlines( ...
							which('missing_page_warning.html'), {@process_callback, data} ...
						);
					else
						out = page_link(site, page, target, tok{4:end});
					end
					
				case {'equations', 'inline-equations', 'eqns', 'ieqns'}
					
					% TODO: use theme colors when creating image
					
					% TODO: complex equations from file
					
					%--
					% create equation image
					%--
					
					opt = latex_image;
					
					try
						opt.text = data.theme.color.text; opt.body = data.theme.color.body;
					catch
						disp('WARNING: Unable to get equation colors from theme.');
					end
					
					cache = latex_image(tok{3}(2:end - 1), '', opt);
					
					if ~isempty(cache)
						
						%--
						% copy image to site images
						%--
						
						[ignore, p2, p3] = fileparts(cache); name = [p2, p3];
						
						file = fullfile(assets_root(site, 'images'), name);

						if ~exist(file, 'file')
							copyfile(cache, file); sites_cache_clear;
						end
						
						%--
						% link image
						%--
						
						% NOTE: inline has 'span' container, display has 'div'
						
						if (type(1) == 'i')
							out = [ ...
								'<span class="equation">', ...
								asset_link(data, 'images', name), ...
								'</span>' ...
							];
						else
							out = [ ...
								'<div class="equation">', ...
								asset_link(data, 'images', name), ...
								'</div>' ...
							];
						end
						
					else
						
						out = {};
					
					end
				
				otherwise
					
					out = {}; disp(['WARNING: Unknown link type ''', type, '''.']);
					
			end
			
		%--
		% include
		%--
		
		case 'include'

			%--
			% inject data
			%--
			
			% NOTE: the first two tokens cannot be injected
	
			for j = 2:length(tok)
				tok{j} = inject(tok{j}, data);
			end
			
			%--
			% get lines to include
			%--
			
			out = '';
			
			switch lower(tok{2})
				
				case 'script'
					
					file = get_asset(site, 'scripts', tok{3});
					
					if ~isempty(file)
			
						out = file_readlines(file, {@process_callback, data});

						out = { ...
							'<script type="text/javascript">', ...
							'<!--', ...
							out{:}, ...
							'// -->', ...
							'</script>' ...
						};
						
					end
					
				case 'file'
					
					% NOTE: we give file a chance by using 'which' and allow full names

					file = which(tok{3});

					if isempty(file) && exist(tok{3}, 'file')
						file = tok{3};
					end
					
					if ~isempty(file)
						out = file_readlines(file, {@process_callback, data});
					end
					
			end

		%--
		% simple variable injection
		%--
		
		otherwise
			
			tok = inject(tok, data);
			
			% NOTE: the first token is the value to inject
			
			out = tok{1};
			
			% NOTE: the second token is a string filter
			
			if length(tok) > 1
				fun = str2func(tok{2}); out = fun(out);
			end

	end

	%--
	% append processing output to output lines
	%--
	
	% TODO: indicate problem if 'out' is not available
		
	if ischar(out)
		out = {out};
	end
		
	for k = 1:length(out)
		lines{end + 1} = out{k};
	end
	
end








