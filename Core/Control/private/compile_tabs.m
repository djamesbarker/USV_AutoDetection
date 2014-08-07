function out = compile_tabs(control)

% compile_tabs - compile tabs layout data
% ---------------------------------------
%
% tabs = compile_tabs(control)
%
% Input:
% ------
%  control - control array
%
% Output:
% -------
%  tabs - compiled tabs

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
% $Revision: 1597 $
% $Date: 2005-08-17 18:33:05 -0400 (Wed, 17 Aug 2005) $
%--------------------------------

% NOTE: output is named 'out' instead of 'tabs' to allow more readable code

%-------------------------------------------------
% SETUP
%-------------------------------------------------

%--
% get tabs indices
%--

tabs_ix = find(strcmpi({control.style},'tabs'));

%--
% return empty quickly when there are no tabs to compile
%---

if (isempty(tabs_ix))
	out = []; return;
end 

%--
% get header indices
%--

type = {control.type};

header_ix = union( ...
	find(strcmpi(type,'header')), find(strcmpi(type,'hidden_header')) ...
);

%-------------------------------------------------
% COMPILE LAYOUT DATA
%-------------------------------------------------

for k = 1:length(tabs_ix)
	
	%--------------------------------------
	% LAYOUT DATA
	%--------------------------------------
	
	tabs.ix = tabs_ix(k);
	
	tabs.name = control(tabs.ix).name;
	
	tabs.tab.name = control(tabs.ix).tab;
	
	tabs.tab.height = zeros(size(tabs.tab.name));
	
	tabs.child.ix = [];
	
	tabs.child.name = cell(0);
	
	tabs.child.parent = cell(0);
	
	%--------------------------------------
	% SELECT CHILDREN
	%--------------------------------------
	
	%--
	% get indices of controls in tabs scope
	%--

	% NOTE: tabs scope is ended by header or end of array
	
	next = min(header_ix(header_ix > tabs.ix));

	if (~isempty(next))
		child_ix = (tabs.ix + 1):(next - 1);
	else
		child_ix = (tabs.ix + 1):length(control);
	end

	%--------------------------------------
	% SORT OUT CHILDREN
	%--------------------------------------
	
	for j = 1:length(child_ix)

		%--------------------------------------
		% GET CHILD
		%--------------------------------------
	
		child = control(child_ix(j));

		%--
		% check tab is properly assigned
		%--
		
		if (isempty(child.tab))
			error(['Control ''' child.name ''' should be assigned to a tab']);
		end
			
		% NOTE: get parent tab index used in height computation
	
		ix = find(strcmpi(tabs.tab.name,child.tab));

		if (isempty(ix))
			error(['Control ''' child.name ''' tab does not correspond to available tabs']);
		end

		%--------------------------------------
		% TAB HEIGHT
		%--------------------------------------
		
		% NOTE: get height works for grouped controls (?)
		
		tabs.tab.height(ix) = tabs.tab.height(ix) + get_height(child);
		
		%--------------------------------------
		% TAB CHILD
		%--------------------------------------
		
		% NOTE: this conditional handles grouped controls as used in button group
		
		if (ischar(child.name))	
			
			tabs.child.ix(end + 1) = child_ix(j);
			
			tabs.child.name{end + 1} = child.name; 
			
			tabs.child.parent{end + 1} = child.tab;		
		
		else	
			
			for i = 1:numel(child.name)
				
				tabs.child.ix(end + 1) = child_ix(j);
				
				tabs.child.name{end + 1} = child.name{i}; 
				
				tabs.child.parent{end + 1} = child.tab;
			
			end

		end
		
	end
	
	%--------------------------------------
	% APPEND TABS TO TABS
	%--------------------------------------
	
	out(k) = tabs;

end
