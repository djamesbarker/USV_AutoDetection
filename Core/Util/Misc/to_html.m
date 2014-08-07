function to_html(s,nrecurs,f)

% to_html - Write data in a structured way using html-code
%    to_html(d,nrecurs,f)
%        d - data
%        nrecurs - maximum level of recursive writing
%            if not given or empty : 1
%        f - filename, file-handle for result
%            if not given : screen
%            if a filename is given a general html begin and end is added.
%
%    arrays are printed if they are small, otherwise they are summarized in one line.
%    Now there is no option to change the definition of "small".
%    It can be changed easily in the code :
%        maxcolarr=4;    : maximum columns to display full array (numeric arrays)
%        maxrowarr=10;   : maximum rows to display full array
%               (this limitation is also used in char-arrays)
%        maxel=20;       : maximum total number of values to display 1D-list of values

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


% Originally this function was made for structures.  By some simple
%    changes it was made to work on other data too.

% Copyright (c)2003, Stijn Helsen <SHelsen@compuserve.com> Januari 2003


if ~exist('nrecurs')|isempty(nrecurs)
	nrecurs=1;
end
ownf=0;
if ~exist('f')
	f=1;
elseif isempty(f)
	f=1;
elseif ischar(f)
	f=fopen(f,'wt');
	if f<3
		error('Can''t open file');
	end
	ownf=1;
	% print html-header
	fprintf(f,'<html>\n<head>\n<title>Matlab-data display</title>\n</head>\n<body>\n');
end

if isstruct(s)
	fields=fieldnames(s);
	if isempty(s)
		fprintf(f,'empty structure (%d fields)<br>\n',length(fields));
	elseif length(s)==1
		fprintf(f,'<table border="1">\n');
		for i=1:length(fields)
			fprintf(f,'<tr><td>%s :</td><td>',fields{i});
			printdata(f,getfield(s,fields{i}),nrecurs-1)
			fprintf(f,'</td></tr>\n');
		end
		fprintf(f,'</table>\n');
	else
		fprintf(f,'<table border="1">\n<tr><td> </td>');
		for i=1:length(fields)
			fprintf(f,'<td>%s</td>',fields{i});
		end
		fprintf(f,'</tr>\n<tr>\n');
		sz=size(s);
		n=prod(sz);
		ndim=sum(sz>1);
		ndim0=length(sz);
		a=cell(1,ndim0);
		for i=1:n
			fprintf(f,'<tr><td valign="top">%d',i);
			if ndim>1	% add full index
				[a{:}]=ind2sub(sz,i);
				fprintf(f,' (%d',a{1});
				fprintf(f,',%d',a{2:ndim0});
				fprintf(f,')');
			end
			fprintf(f,'</td>\n');
			for j=1:length(fields)
				fprintf(f,'<td>');
				printdata(f,getfield(s,{i},fields{j}),nrecurs-1)
				fprintf(f,'</td>\n');
			end	% fields
			fprintf(f,'</tr>\n');
		end	% rows
		fprintf(f,'</table>\n');
	end	% struct array
else
	printdata(f,s,nrecurs)
end

if ownf
	fprintf(f,'</body>\n</html>\n');
	fclose(f);
end

function printdata(f,d,nrecurs)
% printdata - print field-data

maxcolarr=4;
maxrowarr=10;
maxel=20;

sz=size(d);
n=prod(sz);
ndim=sum(sz>1);
ndim0=length(sz);
a=cell(1,ndim0);

switch class(d)
case 'struct'
	if nrecurs>0
		to_html(d,nrecurs,f)
	else
		fprintf(f,'%s structure (%d fields)',stringsize(sz),length(fieldnames(d)));
	end
case {'double','sparse'}
	if ndim0==2&sz(1)<=maxrowarr&sz(2)<=maxcolarr
		fprintf(f,'<table>\n');
		for i=1:sz(1)
			fprintf(f,'<tr>');
			for j=1:sz(2)
				fprintf(f,'<td>%g</td>',d(i,j));
			end
			fprintf(f,'</tr>\n');
		end	% rows
		fprintf(f,'</table>\n');
	elseif n<=maxel
		fprintf(f,'<table>\n');
		for i=1:n
			[a{:}]=ind2sub(sz,i);
			fprintf(f,'<tr><td>%d (%d',i,a{1});
			fprintf(f,',%d',a{2:ndim0});
			fprintf(f,')</td><td>%g</td></tr>\n',d(i));
		end
		fprintf(f,'</table>\n');
	else
		fprintf(f,'%s ',stringsize(sz));
		if issparse(d)
			fprintf(f,'sparse ');
		end
		fprintf(f,'array\n');
	end
case 'cell'
	if n<=maxel&nrecurs>0
		fprintf(f,'<table>\n');
		for i=1:n
			[a{:}]=ind2sub(sz,i);
			fprintf(f,'<tr><td valign="top">%d (%d',i,a{1});
			fprintf(f,',%d',a{2:ndim0});
			fprintf(f,')</td><td>');
			printdata(f,d{i},nrecurs-1);
			fprintf(f,'</td></tr>\n');
		end
		fprintf(f,'</table>\n');
	else
		fprintf(f,'%s cell array\n',stringsize(sz));
	end
case {'int8','uint8','int16','uint16','int32','uint32'}
	if sz(1)<=maxrowarr&sz(2)<=maxcolarr
		printdata(f,double(d),0);
	else
		fprintf(f,'%s %s array\n',stringsize(sz),class(d));
	end
case 'char'
	if ndim0>2|sz(1)>maxrowarr
		fprintf(f,'%s char array',stringsize(sz));
	else
		for i=1:sz(1)
			fprintf(f,'%s<br>\n',d(i,:));
		end
	end
otherwise
	fprintf(f,'%s',class(d));
end

function ssize=stringsize(sz)
ssize=num2str(sz(1));
ssize=[ssize sprintf('x%d',sz(2:end))];
