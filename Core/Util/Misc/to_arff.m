function flag = to_arff(data,labels,names,out)

% to_arff - output class labelled data to arff
% --------------------------------------------
%
% flag = to_arff(data,labels,names,out)
%
% Input:
% ------
%  data - data values table, each column is a feature
%  labels - group labels
%  names - feature names
%  out - output file
%
% Output:
% -------
%  flag - sucess flag

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

% NOTE: Based on 'mat2arff' by Mark Lauback (mark.laubach@yale.edu)

%---------------------------------------------
% HANDLE INPUT
%---------------------------------------------

%--
% set output file interactively
%--

if ((nargin < 4) || isempty(out))

end

%--
% set default feature names
%--

% NOTE: the default feature names are 'F1','F2, ...

if ((nargin < 4) || isempty(names))
	for k = 1:size(data,2)
		names{k} = ['F', int2str(k)];
	end
end

%--
% check size of feature array and group labels
%--

%--
% check type of group labels
%--

% NOTE: we only allow string cell arrays and integers

%--
% check type of feature values
%--

% NOTE: we allow numeric arrays and cell arrays


%---------------------------------------------
% CREATE FILE
%---------------------------------------------

%--------------------------
% create output file
%--------------------------

fid = fopen([out, '.arff'], 'w');

%--------------------------
% write header to file
%--------------------------

%--
% relation
%--

fprintf(fid,['@RELATION ', out, '\n\n']);

%--
% attribute names
%--

[n,N] = size(data);

for I = 1:N
	fprintf(fid,['@ATTRIBUTE ', names{I}, ' REAL\n']);
end

%--
% convert group labels to class values
%--

fprintf(fid,['@ATTRIBUTE Class {', num2str(unique(labels)'), '}\n\n']);

%--------------------------
% write data to file
%--------------------------

fprintf(fid, '@DATA\n');

for I = 1:n,
	for J = 1:N,
		fprintf(fid,['%6.4f,'], data(I,J));
	end
	fprintf(fid,['%1.0f\n'], labels(I));
end

%--------------------------
% close file
%--------------------------

fclose(fid);
