function flag = xml_to_file(str,out,xsl)

% xml_to_file - create xml file
% -----------------------------
%
% flag = xml_to_file(str,out,xsl)
%
% Input:
% ------
%  str - input xml string
%  out - output file
%  xsl - xsl transformation to attach
%
% Output:
% -------
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

%--------------------------------
% HANDLE INPUT
%--------------------------------

%--
% set xsl
%--

if (nargin < 3)
	xsl = '';
end

%--------------------------------
% CREATE XML FILE
%--------------------------------

%--
% open file, create if needed
%--

fid = fopen(out,'wt');

%--
% append header
%--

fprintf(fid,'<?xml version = "1.0" encoding = "UTF-8" ?>\n');

%--
% append style if available
%--

if (~isempty(xsl))
	fprintf(fid,['<?xml:stylesheet type = "text/xsl" href = "' xsl '.xsl" ?>\n']);
end

%--
% append string
%--

% this is assumed to be valid xml

fprintf(fid,str);

%--
% close file
%--

fclose(fid);
