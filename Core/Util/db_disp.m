function out = db_disp(str, var, opt)

% db_disp - display caller message to help debug process
% ------------------------------------------------------
%
% db_disp(str, var, opt)
%
% Input:
% ------
%  str - message string
%  var - variable to display
%  opt - display options

% TODO: clear up state setting code, and overall cleanup

%--------------------------------------
% SETUP
%--------------------------------------

%--
% create persistent display state store
%--

persistent DB_DISP_STATE; 

if isempty(DB_DISP_STATE)
	DB_DISP_STATE = 1;
end

%--
% set display state
%--

flag = 0;

if (nargin == 1) && ~ischar(str)
	
	switch str
		
	case {0,1}
		DB_DISP_STATE = str; flag = 1;

	otherwise
		error('Display state must be zero or one.');
		
	end
	
end

out = DB_DISP_STATE; 

if ~nargout
	clear('out');
end
	
%--
% get and remove ourselves from stack
%--

% NOTE: there are some problems with asking 'dbstack' to omit us from the start

stack = dbstack('-completenames'); stack(1) = [];

%--
% display state when called from the command line
%--

if isempty(stack)
	disp(' '); disp(['DB_DISP is ', ternary(DB_DISP_STATE, 'on', 'off'), '.']); disp(' '); return; 
end

if flag
	return;
end

%--------------------------------------
% HANDLE INPUT
%--------------------------------------

%--
% set options
%--

% NOTE: for the moment we ask for a compact display

if (nargin < 3) || isempty(opt)
	opt = 0;
end

%--
% set empty variable default
%--

if nargin < 2

	var = []; name = [];
	
else
	
	name = inputname(2);
	
	if isempty(name)
		name = 'COMPUTED_VALUE';
	end
	
end

%--
% set empty message default
%--

if nargin < 1
	str = '';
end

%--
% return if state is off
%--

if ~DB_DISP_STATE
	return;
end

%--------------------------------------
% DISPLAY MESSAGE
%--------------------------------------

% TODO: produce a different display string

out.message = str;

out.stack = stack;

% NOTE: we display the variable last

if ~isempty(name)
	out.(name) = var;
end

%--
% display according to options
%--

switch opt
	
	% TODO: make this a link to the editor
	
	case 0
		
% 		prefix = ['''', stack(1).file, ''' at line ', int2str(stack(1).line), ': '];
		
		prefix = stack_line(stack(1), '', 1);
		
		disp([prefix, ': ', out.message]); disp(' ');
		
	% TODO: transform the XML into something that perhaps opens a browser
	
	otherwise, xml_disp(out);
		
end

%--
% suppress output display
%--

if ~nargout
	clear out; 
end
