function out = struct_extract(in)

% struct_extract - extract structure fields to variables in workspace
% -------------------------------------------------------------------
%
% out = struct_extract(in)
%
% Input:
% ------
%  in - structure
%
% Output:
% -------
%  out - names of variables created

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 132 $
% $Date: 2004-12-02 15:58:47 -0500 (Thu, 02 Dec 2004) $
%--------------------------------

% NOTE: this is similar to the function 'extract' in PHP

% TODO: develop extraction modes as in the previously mentioned PHP function

%-----------------------------------
% HANDLE INPUT
%-----------------------------------

%--
% return for empty input
%--

out = [];

if isempty(in)
	return;
end

%--
% check for scalar struct input
%--

% NOTE: use warnings here, since no action is taken

if ~isstruct(in) || numel(in) > 1
	warning('Input must be scalar structure.'); return; %#ok<WNTAG>
end

%-----------------------------------
% EXTRACT
%-----------------------------------

%--
% evaluate to extract
%--

% NOTE: field names are variable names

out = fieldnames(in);

for k = 1:length(out)
	assignin('caller', out{k}, in.(out{k}));
end
