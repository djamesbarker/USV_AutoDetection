function flag = to_r(data,groups,names,filename);

% to_r - output class labelled data to r data frame
% -------------------------------------------------
%
% flag = to_r(data,groups,names,filename)
%
% Input:
% ------
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
% Author: Harold Figueroa
%--------------------------------
% $Revision: 976 $
% $Date: 2005-04-25 19:27:22 -0400 (Mon, 25 Apr 2005) $
%--------------------------------

% NOTE: Based on 'Rsave' by Mark Lauback (mark.laubach@yale.edu)

%---------------------------------------------
% HANDLE INPUT
%---------------------------------------------



%---------------------------------------------
% CREATE FILE
%---------------------------------------------

%--------------------------
% create output file
%--------------------------

fid0 = fopen(filename,'w');

[T,N] = size(data);

fprintf(fid0,['"' filename '" <- data.frame(\n']);
fprintf(fid0,'\n\n');

for n = 1:N

	if (n < 10)
		fprintf(fid0,'\nF00');
		fprintf(fid0,num2str(n));
		fprintf(fid0,' = c(');
	elseif (n < 100)
		fprintf(fid0,'\nF0');
		fprintf(fid0,num2str(n));
		fprintf(fid0,' = c(');
	else
		fprintf(fid0,'\nF');
		fprintf(fid0,num2str(n));
		fprintf(fid0,' = c(');
	end

	fprintf(fid0,['%6.4f,'],data(1:end-1,n));
	fprintf(fid0,['%6.4f),\n'],data(end,n));

end

fprintf(fid0,'\nClass = factor(c(');
fprintf(fid0,'%1.0f,',groups);
uniqueGroups = unique(groups);
fprintf(fid0,'),label = c(');

for i = 1:size(uniqueGroups)
	fprintf(fid0,'%d,', uniqueGroups(i));
	%        fprintf(fid0,'"%s",', num2str(uniqueGroups(i)));
end

fprintf(fid0,')))');

%--
% close output file
%--

fclose(fid0);
