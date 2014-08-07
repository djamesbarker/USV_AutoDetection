function process_template(view,name,data,path,out)

% process_template - inject data into template
% --------------------------------------------
%
% process_template(view,name,data,path,out)
%
% Input:
% ------
%  view - view name
%  name - template name
%  data - template data
%  path - output file directory
%  out - output file name

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
% $Revision: 2014 $
% $Date: 2005-10-25 17:43:52 -0400 (Tue, 25 Oct 2005) $
%--------------------------------

%-----------------------------------
% HANDLE INPUT
%-----------------------------------

%--
% set default no output rename
%--

if (nargin < 5)
	out = [];
end

%-----------------------------------
% SETUP
%-----------------------------------

%--
% get input template
%--

in = get_template(view,name);

%--
% set output file
%--

% NOTE: default output name is same as input name

if (isempty(out))
	out = [name, '.html'];
end

out = [path, filesep, out];

%-----------------------------------
% PROCESS TEMPLATE
%-----------------------------------

%--
% handle missing template
%--

% TODO: handle missing templates uniformly with framework

if (isempty(in))
	missing_template(out,data); return;
end
	
%--
% execute template callback
%--

% TODO: integrate processing and write

lines = in(data);

file_writelines(out,lines);


%-----------------------------------
% MISSING_TEMPLATE
%-----------------------------------

function missing_template(view,name,data,out)

%--
% open file
%--

fid = fopen(out,'w');

if (fid == -1)
	return;
end

%--
% produce missing template message
%--

%--
% display template data
%--

% TODO: create entity replacement function, try to be efficient

str = to_xml(data);

str = strrep(str,'<','&lt;');
str = strrep(str,'>','&gt;');

% NOTE: we display the template data as preformatted xml

fprintf(fid,['<pre>', str, '</pre>']); 

%--
% close file
%--

fclose(fid);
	
