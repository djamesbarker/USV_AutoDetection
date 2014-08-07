function [out,id,ix] = get_event_measurements(name,varargin)

% get_event_measurements - get event measurement data from log
% ------------------------------------------------------------
%
%  [measurement,id,ix] = get_event_measurements(name,log,ix)
%
%        [param,id,ix] = get_event_measurements(name,'parameters',log,ix)
%        [value,id,ix] = get_event_measurements(name,'values',log,ix)
%
%        [field,id,ix] = get_event_measurements(name,field,log,ix)
%
% Input:
% ------
%  name - name of measurement
%  field - name of measurement field
%  log - input log
%  ix - event indices in log
%
% Output:
% -------
%  measurement - measurement structure array
%  param - measurement parameter array
%  value - measurement value array
%  field - measurement field array
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
% handle variable input
%--

switch (length(varargin))
	
	%--
	% called as log_measurement(name,log)
	%--
	
	case (1)
		
		field = '';
		log = varargin{1};
		ix = [];
	
	case (2)
		
		%--
		% called as log_measurement(name,field,log)
		%--
	
		if (isstruct(varargin{2}))
			
			field = varargin{1};
			
			log = varargin{2};
			
			if (~strcmp(log.type,'log'))
				disp(' ');
				error('Log input variable is not of type log.');
			end
		
			ix = [];
			
		%--
		% called as log_measurement(name,log,ix)
		%--
	
		else
			
			field = '';
			
			log = varargin{1};
			
			if (~strcmp(log.type,'log'))
				disp(' ');
				error('Log input is not of type log.');
			end
			
			ix = varargin{2};
			
		end
		
	%--
	% called as log_measurement(name,field,log,ix)
	%--
	
	case (4)
		
		field = varargin{1}; 
		log = varargin{2};
		ix = varargin{3};
		
end

%--
% check name of measurement
%--

[MEAS,MEAS_NAME] = get_measurements;

ixm = find(strcmp(MEAS_NAME,name));

if (isempty(ixm))
	disp(' ');
	error(['Unrecognized measurement ''' name '''.']);
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
	
	if (strcmp(field,'values') | strcmp(field,'parameters'))
		
		type = field;
		field = '';
		
	%--
	% get specific field from parameters or values
	%--
	
	else
		
		%--
		% get measurement description
		%--
		
		DESC = feval(MEAS(ixm).fun,'describe');
		
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
		
		% check in parameter field names
		
		if (~flag)
			
			ixf = find(strcmp(DESC.parameter.field,field));
			
			if (~isempty(ixf))
				type = 'parameter';
				field = DESC.parameter.struct{ixf};
				flag = 1;
			end
			
		end
		
		% check in parameter struct fields
		
		if (~flag)
			
			ixf = find(strcmp(DESC.parameter.struct,field));
			
			if (~isempty(ixf))
				type = 'parameter';
				field = DESC.parameter.struct{ixf};
				flag = 1;
			end
			
		end
				
		% error
		
		if (~flag)
			
			%--
			% display available fields
			%--

			% value fields
			
			msg = ['Available Value Fields for ''' name ''':'];
			sep = char(45 * ones(1,length(msg)));
			
			disp(' ');
			disp(sep);
			disp(msg);
			disp(sep);
			disp(' ');

			c1 = char(ones(length(DESC.value.field),1) * double('  '));
			
			tmp = [char(DESC.value.field), c1, char(DESC.value.struct)];
			
			for k = 1:length(DESC.value.field)
				disp(tmp(k,:));
			end
			
			% parameter fields
			
			msg = ['Available Parameter Fields for ''' name ''':'];
			sep = char(45 * ones(1,length(msg)));
			
			disp(' ');
			disp(sep);
			disp(msg);
			disp(sep);
			disp(' ');
			
			c1 = char(ones(length(DESC.parameter.field),1) * double('  '));
			
			tmp = [char(DESC.parameter.field), c1, char(DESC.parameter.struct)];
			
			for k = 1:length(DESC.parameter.field)
				disp(tmp(k,:));
			end
			
			%--
			% report error
			%--
			
			disp(' ');
			error(['Unrecognized measurement field ''' field '''']);
			
		end
		
	end 
	
end

%--
% extract events from log
%--

if (isempty(ix))
	event = log.event;
else
	event = log.event(ix);
end 

%--
% get measurements from events
%--

j = 1;

for k = 1:length(event)
	
	%--
	% get index of measurement in event
	%--
	
	ixa = find(strcmp(struct_field(event(k).measurement,'name'),name));
	
	%--
	% get measurement if it exists, along with event id and current index
	%--
	
	if (~isempty(ixa))
		
		out(j) = event(k).measurement(ixa); 
		id(j) = event(k).id;
		ixt(j) = k;
		
		j = j + 1;
		
	end
	
end

%--
% get values, parameters, or field if needed
%--

if (~isempty(type))
		
	%--
	% get values or parameters
	%--
	
	out = struct_field(out,type);
	
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
