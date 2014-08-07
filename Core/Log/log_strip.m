function log = log_strip(log,name)

% log_strip - remove metadata from log
% ------------------------------------
%
% log = log_strip(log,name)
%
% Input:
% ------
%  log - log to strip
%  name - measurement and annotation names (def: dialog)
%
% Output:
% -------
%  log - stripped log

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
% $Revision: 1215 $
% $Date: 2005-07-19 23:57:12 -0400 (Tue, 19 Jul 2005) $
%--------------------------------

% TODO: we need a place to put this and various other log level functions,
% clearly one place for these is a context menu that stems from a log (verb
% to apply to noun) however some verb noun like interface to these
% operations 

%--
% get measurements and annotations
%--

meas = get_measurements;

annot = get_annotations;

%--
% get names
%--

if ((nargin < 2) | isempty(name))
	
	%--
	% annotation selection control
	%--
	
	nm = length(meas);
	
	L = struct_field(meas,'name');
	
	control(1) = control_create( ...
		'name','Annotation', ...
		'tooltip','Annotations to strip from log', ...
		'style','listbox', ...
		'min',0, ...
		'max',2, ...
		'lines',max(min(8,(nm + 0.5)),1.1), ...
		'value',[], ...
		'string',L ...
	);
	
	%--
	% measurement selection control
	%--
	
	nm = length(meas);
	
	L = struct_field(meas,'name');
	
	control(2) = control_create( ...
		'name','Measure', ...
		'tooltip','Measures to strip from log', ...
		'style','listbox', ...
		'min',0, ...
		'max',2, ...
		'lines',max(min(8,(nm + 0.5)),1.1), ...
		'value',[], ...
		'string',L ...
	);

	%--
	% create dialog to select metadata to strip
	%--
		
	out = dialog_group(['Strip  -  ' file_ext(log.file)],control,[],[],gcf);
	
end
	
