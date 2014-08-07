function info = palette_kpfun(h,flag)

% palette_kpfun - palette key press function
% ------------------------------------------
%
% palette_kpfun(h)
%
% Input:
% ------
%  h - handle to palette parent

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
% $Revision: 3168 $
% $Date: 2006-01-11 16:54:20 -0500 (Wed, 11 Jan 2006) $
%--------------------------------

% TODO: get accelerator keys used in palette and don't send them to parent

%--
% set empty output default
%--

info = [];

%----------------------------------------------
% HANDLE INPUT
%----------------------------------------------

%--
% set info flag (only used to generate documentation)
%--

if (nargin < 2) || isempty(flag)
	flag = 0;
end

%--
% get palette handle and current character and key
%--

% NOTE: 'currentcharacter' and 'currentkey' are different

% NOTE: key 'm' is always 'm', character 'm' is 'M' when shift is down

if nargin < 2
		
	pal = gcf;
	
	chr = get(pal,'currentcharacter'); code = double(chr);
	
	key = get(pal,'currentkey');

else
	
	% TODO: is this ever used, what does this do?
	
	chr = char(h); code = h;
	
	key = char(h);

end

%--
% return on empty characters if we have the info flag
%--

if isempty(code) && flag
	return;
end

%--
% create key info
%--

if (flag)
	info = kinfo_create(code);
end

%--
% get accelerators
%--

% NOTE: don't send message to parent on accelerators

g = findall(pal,'type','uimenu');

if (~isempty(g))
	acc = lower(unique(get(g,'accelerator')));
else
	acc = cell(0);
end

%--
% provide generic functionality to the control group through the key press
%--

switch (key)
		
	%----------------------------------------------
	% MIN OR MAX PALETTE
	%----------------------------------------------
	
	% NOTE: we use of both key and char in this branch
	
	case ({'m','M'})
		
		%-------
		% INFO
		%-------
				
		if (flag)
			
			if (chr == 'm')
					
				info.name = 'Minimize Palette';
				info.category = 'Window'; 
				info.description = [ ...
					'Minimize current palette by closing all headers.' ...
				];
				
				return;
				
			else
				
				info.name = 'Maximize Palette';
				info.category = 'Window'; 
				info.description = [ ...
					'Maximize current palette by opening all headers.' ...
				];
				
				return;
				
			end
					
		end
		
		%--
		% minimize or maximize palette
		%--
		
		if (chr == 'm')
			palette_minmax('min',pal);
		else
			palette_minmax('max',pal);
		end
		
		return;
		
	%----------------------------------------------
	% CLOSE PALETTE
	%----------------------------------------------
	
	case ('w')
		
		%-------
		% INFO
		%-------
		
		if (flag)
			
			info.name = 'Close Palette';
			info.category = 'Window'; 
			info.description = [ ...
				'Close current palette.' ...
			];
			
			return;
			
		end
		
		close(pal); return;
		
	%----------------------------------------------
	% CANCEL ADD USING SHIFT
	%----------------------------------------------
	
	% FIXME: the minimal dialog has problems using this modifier
	
	% NOTE: it is not clear that this can be fixed at our level
	
	case ('shift')
				
		%-------
		% INFO
		%-------
		
		if (flag)
			return;
		end
		
		h = overobj('uicontrol');
		
		if (~isempty(h) && strcmp(get(h,'style'),'pushbutton'))
			
			if (strcmp(get(h,'string'),'+'))
				
				%--
				% set the string to minus wait and then reset
				%--
				
				set(h,'string','-');
			
				pause(1.2); % try to avoid flickering
				
				% NOTE: the button may have been deleted in the meantime
				
				try
					set(h,'string','+');
				end
				
			end
			
		end
		
	%----------------------------------------------
	% ACCELERATORS
	%----------------------------------------------
	
	case (acc), return;
		
	%----------------------------------------------
	% SEND MESSAGE TO PARENT
	%----------------------------------------------

	otherwise
		
		% NOTE: this is a hack to distinguish between code and handle input
		
		try 
			get(h,'type');
		catch
			info = []; return;
		end
		
end

%--
% return if a special key was pressed
%--

if length(key) > 1
	return;
end

%--
% make parent browser current figure and call its key press function
%--

% NOTE: there are problems in the hand-off key press to parent

if nargin && ~isempty(h)
	
	% TODO: consider calling a generic parent key press function
	
	figure(h); browser_kpfun(chr);
	
end
