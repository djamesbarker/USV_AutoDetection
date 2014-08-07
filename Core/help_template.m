function f = help_template(name)

% help_template - create help template
% ------------------------------------
%
% flag = help_template(name)
%
% Input:
% ------
%  name - name of annotation or measurement
%
% Output:
% -------
%  flag - template creation flag

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

%--
% get annotations and measurents
%--

[ANNOT,ANNOT_NAME] = get_annotations;
[MEAS,MEAS_NAME] = get_measurements;

%--
% find name in annotations and measurements
%--

ix = [];
type = '';

ix = find(strcmp(ANNOT_NAME,name)); 
if (~isempty(ix))
	fun = ANNOT(ix).fun;
	type = 'annotation';
end

if (isempty(ix))
	ix = find(strcmp(MEAS_NAME,name));
	if (~isempty(ix))
		fun = MEAS(ix).fun;
		type = 'measurement';
	end
end

if (isempty(ix))
	disp(' ');
	error(['''' name ''' was not found among available annotations or measurements.']);
end

%--
% create description of annotation or measurement
%--

description = feval(fun,'describe');

%--
% create help template files
%--

note = 'PUT DESCRIPTION HERE';

switch (type)
	
	case ('annotation')
		
		%--
		% create structure to be converted into xml help template
		%--

		% annotation documentation
		
		annotation.name = description.name;
		annotation.description = note;
		
		% value documentation
		
		for k = 1:length(description.value.field)
			eval(['annotation.value(k).name = ''' description.value.field{k} ''';']);
			eval(['annotation.value(k).field = ''' description.value.struct{k} ''';']);
			eval(['annotation.value(k).tip = ''' description.value.tip{k} ''';']);
			eval(['annotation.value(k).description = ''' note ''';']);
		end
		
		%--
		% create xml from structure
		%--
		
		str = struct_to_xml(annotation);
		
		%--
		% create file
		%--
		
		file = functions(fun);		
		file = strrep(file.file,'.m','_help.xml');
		
		str_to_file(str,file);
		
		
	case ('measurement')
		
		%--
		% create structure to be converted into xml help template
		%--

		% measurement documentation
		
		measurement.name = description.name;
		measurement.description = note;
		measurement.algorithm = note;
		
		% value documentation
		
		for k = 1:length(description.value.field)
			eval(['measurement.value(k).name = ''' description.value.field{k} ''';']);
			eval(['measurement.value(k).field = ''' description.value.struct{k} ''';']);
			eval(['measurement.value(k).tip = ''' description.value.tip{k} ''';']);
			eval(['measurement.value(k).description = ''' note ''';']);
		end
		
		% parameter docuemntation
		
		for k = 1:length(description.value.field)
			eval(['measurement.parameter(k).name = ''' description.parameter.field{k} ''';']);
			eval(['measurement.parameter(k).field = ''' description.parameter.struct{k} ''';']);
			eval(['measurement.parameter(k).tip = ''' description.parameter.tip{k} ''';']);
			eval(['measurement.parameter(k).description = ''' note ''';']);
		end
		
		%--
		% create xml from structure
		%--
		
		str = struct_to_xml(annotation);
		
		%--
		% create file
		%--
		
		file = functions(fun);		
		file = strrep(file.file,'.m','_help.xml');
		
		str_to_file(str,file);
		
end

