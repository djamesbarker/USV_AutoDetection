function out = struct_copy(in, out, match)

% struct_copy - copy fields from one structure to another
% -------------------------------------------------------
%
% out = struct_copy(in, out, match)
%
% Input:
% ------
%  in - source struct
%  out - destination struct
%  match - field match array for differently named fields
%
% Output:
% -------
%  out - structure with copied data

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 765 $
% $Date: 2005-03-18 18:48:00 -0500 (Fri, 18 Mar 2005) $
%--------------------------------

%---------------------------------------------
% HANDLE INPUT
%---------------------------------------------

%--
% set empty match table
%--

if nargin < 3
	match = [];
end

%---------------------------------------------
% GET SOURCE FIELDS
%---------------------------------------------

%--
% get structure fields
%--

in_field = fieldnames(in);

out_field = fieldnames(out);

source_field = cell(size(out_field));

%--
% check match array fields for correctness
%--

% NOTE: this may be turned off for speed

%--
% findout which fields are to be written and with what
%--

for k = length(out_field):-1:1
	
	%--
	% check for field in the match array
	%--
	
	% NOTE: the order is important. match entries override same name copy
	
	if ~isempty(match)
		
		% NOTE: the first column of the match array contains the output fields

		ix = find(strcmp(out_field{k}, match(:,1)));

		% NOTE: the second column of the match array contains the input fields

		if ~isempty(ix)
			source_field{k} = match{ix, 2}; continue;
		end
		
	end
	
	%--
	% check for field in the input structure
	%--
	
	ix = find(strcmp(out_field{k}, in_field));
	
	if ~isempty(ix)
		source_field{k} = in_field{ix}; continue;
	end
	
	%--
	% remove this output field from copy consideration
	%--
	
	out_field(k) = []; source_field(k) = [];
	
end

%---------------------------------------------
% COPY FIELDS
%---------------------------------------------

for k = 1:length(out_field)
	out.(out_field{k}) = in.(source_field{k});
end
