function [C,ix] = channel_matrix_update(C,str,ch)

% channel_matrix_update - update channel matrix
% ---------------------------------------------
%
% [C,ix] = channel_matrix_update(C,str,ch)
%
% Input:
% ------
%  C - channel matrix
%  str - update command string
%
%    'top' - move channels to top
%    'bottom' - move channels to bottom
%    'up' - move channels up
%    'down' - move channels down
%
%    'display' - set specific channels for display
%    'hide' - remove channels from display
%    'show' - add channels to display
%    'toggle' - toggle display of channel
%
%  ch - channels involved
%
% Output:
% -------
%  C - updated channel matrix
%  ix - output indices of updated channels

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
% $Revision: 132 $
% $Date: 2004-12-02 15:58:47 -0500 (Thu, 02 Dec 2004) $
%--------------------------------

%--
% get number of channels
%--

n = size(C,1);

%--
% get channel row indices
%--

for k = 1:length(ch)
	ix(k) = find(C(:,1) == ch(k));
end
		
%--
% switch depending on command string
%--

switch (lower(str))
	
	%--------------------------------------------------------
	% ORDER UPDATES
	%--------------------------------------------------------
	
	%--
	% move channel group to top
	%--
	
	case ('top')

		%--
		% update channel matrix
		%--
		
		D = C(ix,:); % copy selected channels
		
		C(ix,:) = []; % remove selected channels
		
		C = [D; C]; % concatenate channels
		
		%--
		% output resulting indices
		%--
		
		ix = 1:length(ix);
		
	%--
	% move channel group to bottom
	%--
	
	case ('bottom')

		%--
		% update channel matrix
		%--
		
		D = C(ix,:); % copy selected channels
		
		C(ix,:) = []; % remove selected channels
		
		C = [C; D]; % concatenate channels
		
		%--
		% output resulting indices
		%--
		
		n = length(ix);
		ix = size(C,1);
		
		ix = (ix - n + 1):ix;
		
	%--
	% move single channel up
	%--
	
	case ('up')
		
		%--
		% consider multiple and single channel move separately
		%--
		
		if (length(ch) > 1)
			
			%--
			% get initial indices of channels to move
			%--
			
			for k = 1:length(ch)
				ix1(k) = find(C(:,1) == ch(k));
			end
			
			ix1 = sort(ix1);
			
			%--
			% compute new indices for channels to move
			%--
			
			if (ix1(1) == 1)
				return; 
			else
				ix2 = ix1 - 1;
			end
			
			%--
			% update channel matrix
			%--
			
			D = C;
						
			ixc = setdiff(1:size(C,1),ix2);
			
			C(ix2,:) = D(ix1,:);
			
			D(ix1,:) = [];	
			
			C(ixc,:) = D;
			
			%--
			% output resulting indices
			%--
			
			ix = ix2;
			
		else

			%--
			% move channel rows
			%--
			
			if (ix == 1)
				return; 
			else
				
				%--
				% update channel matrix
				%--
				
				C = [C(1:ix - 2,:); C(ix,:); C(ix - 1,:); C(ix + 1:end,:)];
				
				%--
				% output resulting index
				%--
				
				ix = ix - 1;
				
			end
			
		end
		
	%--
	% move single channel down
	%--
	
	case ('down')
		
		%--
		% consider multiple and single channel move separately
		%--
		
		if (length(ch) > 1)
			
			%--
			% get initial indices of channels to move
			%--
			
			for k = 1:length(ch)
				ix1(k) = find(C(:,1) == ch(k));
			end
			
			ix1 = sort(ix1);
			
			%--
			% compute new indices for channels to move
			%--
			
			if (ix1(end) == size(C,1))
				return; 
			else
				ix2 = ix1 + 1;
			end
			
			%--
			% update channel matrix
			%--
			
			D = C;
						
			ixc = setdiff(1:size(C,1),ix2);
			
			C(ix2,:) = D(ix1,:);
			
			D(ix1,:) = [];	
			
			C(ixc,:) = D;
			
			%--
			% output resulting indices
			%--
			
			ix = ix2;
			
		else

			%--
			% move channel rows
			%--
			
			if (ix == n)
				return; 
			else
				
				%--
				% update channel matrix
				%--
				
				C = [C(1:ix - 1,:); C(ix + 1,:); C(ix,:); C(ix + 2:end,:)];
				
				%--
				% output resulting index
				%--
				
				ix = ix + 1;
				
			end
			
		end
		
	%--------------------------------------------------------
	% DISPLAY UPDATES
	%--------------------------------------------------------
	
	% there is clearly some redundancy here in the channel display commands
	% nevertheless this makes calling the update more transparent
	
	%--
	% toggle the display of a channel
	%--
	
	case ('toggle')
		
		for k = 1:length(ix)
			C(ix(k),2) = double(~C(ix(k),2));
		end
		
	%--
	% hide channels
	%--
	
	case ('hide')
		
		C(ix,2) = 0;
		
	%--
	% show channels
	%--
	
	case ('show')
		
		C(ix,2) = 1;
		
	%--
	% set the channel display completely
	%--
	
	case ('display')
		
		C(:,2) = 0;
		C(ix,2) = 1;
		
	%--------------------------------------------------------
	% ERROR
	%--------------------------------------------------------
	
	otherwise
		
		disp(' ');
		error(['Unrecognized channel matrix update command ''' str '''.']);
		
end
		
