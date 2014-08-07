function varargout = channel_strings(varargin)

% channel_strings - convert channel strings and channel matrix
% ------------------------------------------------------------
%
% [L,value] = channel_strings(C)
%
%         C = channel_strings(L,value)
%
% Input:
% ------
%  C - channel matrix
%  L - channel strings (from listbox)
%  value - channel values (from listbox)
%
% Output:
% -------
%  L - channel strings (from listbox
%  value - channel values (from listbox)
%  C - channel matrix

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
% compute depending on number of inputs
%--

switch (length(varargin))
	
	%--
	% convert channel matrix to channel strings and values
	%--
	
	% the output may be used to set a listbox controls
	
	case (1)
		
		%--
		% rename input
		%--
		
		C = varargin{1}; % channel matrix
		
		%--
		% create strings
		%--
		
		for k = 1:size(C,1)
			L{k} = ['Channel ' int2str(C(k,1))];
		end
		
		%--
		% create values
		%--
		
		value = find(C(:,2));
		
		%--
		% rename output
		%--
		
		varargout{1} = L; % string for listbox control
		
		varargout{2} = value; % value for listbox control
		
	%--
	% convert channel strings and values to channel matrix
	%--
	
	% the input may be obtained from a listbox control
	
	case (2)
		
		%--
		% rename input
		%--
		
		L = varargin{1}; % listbox string
		
		value = varargin{2}; % listbox value
		
		%--
		% generate corresponding channel matrix
		%--
		
		C = zeros(length(L),2);
		
		n = length('Channel ');

		% set channel indices in string cell array order
		
		for k = 1:length(L)
			
			% this safeguard may not be needed if we do away with the
			% display of the play channels in the channel display
			
			if (length(L{k}) <= (n + 2))
				C(k,1) = round(str2double(L{k}(n:end)));
			else
				C(k,1) = str2double(L{k}(n:(n + 2)));
			end
			
		end
		
		C(value,2) = 1; % set displayed channels
		
		%--
		% rename output
		%--
		
		varargout{1} = C;
		
	%--
	% error
	%--
	
	otherwise
		
		disp(' ')
		error('Incorrect number of arguments.');
		
end
