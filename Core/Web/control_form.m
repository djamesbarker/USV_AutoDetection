function control_form(control,name,fun,out)

% control_form - render a set of controls as a form
% -------------------------------------------------
%
% out = control_form(control,out)
%
% Input:
% ------
%  control - array of controls
%  name - name of form
%  fun - form processing function
%  out - output file
%
% Output:
% -------
%  out - output file

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


%-------------------------------------
% HANDLE INPUT
%-------------------------------------

if ((nargin < 4) || isempty(out))
	out = 'test.html';
end

%--
% set default processing function
%--

% TODO: create a diagnostic default function to test the interface

if ((nargin < 3) || isempty(fun))
	fun = 'test';
end

%-------------------------------------
% CREATE AND OPEN OUTPUT FILE
%-------------------------------------

fid = fopen(out,'w');

if (~fid)
	
	disp(' ');
	error(['Unable to open output file ''' out '''.']);

end

%-------------------------------------
% CREATE CONTROLS FORM
%-------------------------------------

%--
% open matlab webserver form container
%--

str = [ ...
	'<DIV class = "control_form" name = "' name '">'
	'<FORM action = "/cgi-bin/matweb.exe" method = "post">\n', ...
	'<INPUT type = "hidden" name = "mlmfile" value = "' fun '">' ...
];

fprintf(fid,str);

%--
% add controls as input
%--

for k = 1:length(control)
	
	% create convenient copy of control
	
	ck = control(k);
	
	%--
	% set control label
	%--

	if (ck.label)
		if (~isempty(ck.alias))
			label = ck.alias;
		else
			label = ck.name;
		end
	else
		label = '';
	end
	
	%--
	% create control string based on type
	%--
			
	switch (ck.style)
		
		case ('axes')
			
		case ('buttongroup')
		
		%--
		% checkbox control
		%--
		
		% NOTE: this is simply an html input of checkbox type
		
		case ('checkbox')
			
			str = ['<INPUT type = "checkbox" name = "' ck.name '">' label '</INPUT>'];
					
		%--
		% edit control
		%--
		
		% NOTE: this is simply an html input of text type
		
		case ('edit')
			
		%--
		% listbox
		%--
				
		case ('listbox')
			
		%--
		% popup
		%--
		
		% NOTE: this is simply an html input of select type
		
		case ('popup')
			str = ''
			
		case ('separator')
			
		case ('slider')
			
		case ('tabs')
			
		case ('waitbar')
			
		otherwise
			
	end
	
	%--
	% output control string
	%--
	
	fprintf(fid,str);
	
end
	
%--
% close matlab webserver form container
%--

str = [ ...
	'</FORM>\n', ...
	'</DIV>\n' ...
];

fprintf(fid,str);

%--
% close output file
%--

fclose(fid);

