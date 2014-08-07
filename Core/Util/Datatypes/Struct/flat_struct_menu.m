function handles = flat_struct_menu(par, value, context)

% flat_struct_menu - flatten one level of struct menu
% ---------------------------------------------------
%
% handles = flat_struct_menu(par, value, context)
%
% Input:
% ------
%  par - menu parent
%  value - value to display
%
% Output:
% -------
%  handles - menu handles

% TODO: the context should allow for transformation and unit indication

% NOTE: if we use the context in such a way this function should be renamed

%--
% initialize handles
%--

handles = [];

%--
% create a menu section for each struct field
%--

header = fieldnames(value);

for k = 1:numel(header)
	
	if ~isstruct(value.(header{k}))
		continue;
	end
	
	handles(end + 1) = uimenu(par, 'label', ['(', title_caps(header{k}), ')'], 'enable', 'off'); %#ok<AGROW>
	
	% NOTE: the internal headers have a separator to separate menu sections
	
	if k > 1
		set(handles(end), 'separator', 'on');
	end
	
	handles = [handles, struct_menu(par, value.(header{k}))]; %#ok<AGROW>
end
