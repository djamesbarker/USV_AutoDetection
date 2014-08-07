function control = section_collapse_control(space)

% section_collapse_control - thin header to collapse other controls
% -----------------------------------------------------------------
%
% control = section_collapse_control(space)
%
% Input:
% ------
%  space - bottom-margin for header (def: 0.11 tiles)
%
% Output:
% -------
%  control - control

%--
% set default space
%--

if ~nargin
	space = 0.11; 
end

%--
% create thin header to collapse other controls
%--

% TODO: this should be a named control function

color = 0.92 * ones(1, 3); color(3) = 0.85;

control = control_create( ...
	'style', 'separator', ...
	'type', 'header', ...
	'color', color, ...
	'lines', 0.8, ...
	'space', space ...
);
