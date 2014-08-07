function tool = get_mingw_tool(name)

% get_mingw_tool - considering where mingw is
% -------------------------------------------
%
% tool = get_mingw_tool(name)
%
% Input:
% ------
%  name - of tool
%
% Output:
% -------
%  tool - found
%
% See also: get_tool, mingw_root

if isempty(mingw_root)
	tool = get_tool(name);
else
	start = pwd; cd(mingw_root); tool = get_tool(name); cd(start);
end
