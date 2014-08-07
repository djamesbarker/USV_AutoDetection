function [out,id,ix] = log_annotations(varargin)

% log_annotations - get annotation data from log
% ----------------------------------------------
%
%  [annotation,id,ix] = log_annotations(name,log,ix)
%
%       [value,id,ix] = log_annotations(name,'value',log,ix)
%
%       [field,id,ix] = log_annotations(name,field,log,ix)
%
% Input:
% ------
%  name - name of annotation
%  field - name of annotation field
%  log - input log
%  ix - event indices in log
%
% Output:
% -------
%  annotation - annotation structure array
%  value - annotation value array
%  param - annotation parameter array
%  field - annotation field array
%  id - event ids
%  ix - event indices in log

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
% $Revision: 132 $
% $Date: 2004-12-02 15:58:47 -0500 (Thu, 02 Dec 2004) $
%--------------------------------

%--
% handle input
%--

switch (nargin)
	
	%--
	% log_annotation(name,log)
	%--
	
	case (2)
		
		name = varargin{1};
		field = '';
		log = varargin{2};
		ix = [];
	
	case (3)
		
		%--
		% log_annotation(name,field,log)
		%--
	
		if (isstruct(varargin{3}))
			
			name = varargin{1};
			field = varargin{2};
			log = varargin{3};
			ix = [];
			
		%--
		% log_annotation(name,log,ix)
		%--
	
		else
			
			name = varargin{1};
			field = '';
			log = varargin{2};
			ix = varargin{3};
			
		end
		
	%--
	% log_annotation(name,field,log,ix)
	%--
	
	case (4)
		
		name = varargin{1};
		field = varargin{2}; 
		log = varargin{3};
		ix = varargin{4};
		
end

%--
% check name of annotation
%--

[ANNOT,ANNOT_NAME] = get_annotations;

ixm = find(strcmp(ANNOT_NAME,name));

if (isempty(ixm))
	disp(' ');
	error(['Unrecognized annotation ''' name '''.']);
end

%--
% check name of field if needed
%--

if (isempty(field))
	
	type = '';
	
else
	
	%--
	% get parameter or value structures
	%--
	
	if (strcmp(field,'value') | strcmp(field,'param'))
		
		type = field;
		field = '';
		
	%--
	% get specific field from parameters or values
	%--
	
	else
		
		%--
		% get annotation description
		%--
		
		ANNOT(ixm)
		
		DESC = feval(ANNOT(ixm).fun,'describe');
		
		%--
		% find desired field among parameters or values
		%--
		
		flag = 0;
		
		% check in value field names
		
		if (~flag)
			ixf = find(strcmp(DESC.value.field,field));
			if (~isempty(ixf))
				type = 'value';
				field = DESC.value.struct{ixf};
				flag = 1;
			end
		end
		
		% check in value struct fields
		
		if (~flag)
			ixf = find(strcmp(DESC.value.struct,field));
			if (~isempty(ixf))
				type = 'value';
				field = DESC.value.struct{ixf};
				flag = 1;
			end
		end
				
		% error
		
		if (~flag)
			disp(' ');
			error(['Unrecognized measurement field ''' field '''']);
		end
		
	end 
	
end

%--
% extract events from log if needed
%--

if (isempty(ix))
	event = log.event;
else
	event = log.event(ix);
end 

%--
% get annotations from log
%--

j = 1;

for k = 1:length(event)
	
	% get index of annotation in event
	
	ixa = find(strcmp(struct_field(event(k).annotation,'name'),name));
	
	% get annotation if it exists, along with event id and current index
	
	if (~isempty(ixa))
		out(j) = event(k).annotation(ixa); 
		id(j) = event(k).id;
		ixt(j) = k;
		j = j + 1;
	end
	
end

%--
% get values or field if needed
%--

if (~isempty(type))
	
	%--
	% get values or parameters
	%--
	
	out = struct_field(out,'type');
	
	%--
	% get field if needed
	%--
	
	if (~isempty(field))
		out = struct_field(out,field);
	end
	
end

%--
% dereference indices if needed
%--

if (isempty(ix))
	ix = ixt;
else
	ix = ix(ixt);
end
