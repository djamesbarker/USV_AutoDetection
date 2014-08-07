function adapters = get_adapters

% get_adapters - get analog input adapters
% ----------------------------------------
%
% adapters = get_adapters
%
% Output:
% -------
%  adapters - array of structured adapter info

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
% Author: Matt Robbins, Harold Figueroa
%--------------------------------
% $Revision: 2196 $
% $Date: 2005-12-02 18:16:46 -0500 (Fri, 02 Dec 2005) $
%--------------------------------

%---------------------------------
% RETURN ADAPTER CACHE
%---------------------------------

persistent PERSISTENT_DAQ_ADAPTERS;

if (~isempty(PERSISTENT_DAQ_ADAPTERS))
	adapters = PERSISTENT_DAQ_ADAPTERS; return;
end

%---------------------------------
% BUILD ADAPTER CACHE
%---------------------------------

%--
% get available adapter types
%--

type = get_field(daqhwinfo,'InstalledAdaptors');

%--
% select adapters available as analog input devices
%--

adapters = [];

for k = 1:length(type)

	%--
	% get adapter info and test if device is available as analog input
	%--
	
	info = daqhwinfo(type{k});
	
	% NOTE: empty contstructor name indicates problems with drivers
	
	% NOTE: first element of field contains code to instantiate device as analog input
	
	if (isempty(info.ObjectConstructorName) || isempty(info.ObjectConstructorName{1}))
		continue;
	end
	
	%--
	% get and pack adapter info to output
	%--
	
	for j = 1:length(info.InstalledBoardIds);

		% NOTE: we keep the constructor in case this changes
		
		adapter = struct( ...
			'type', type{k}, ...
			'ID', info.InstalledBoardIds{j}, ...
			'name', info.BoardNames{j}, ...
			'fun', info.ObjectConstructorName{1} ...
		);

		if (isempty(adapters))
			adapters = adapter;
		else
			adapters(end + 1) = adapter;
		end

	end

end

%--
% copy discovered adapters to cache
%--

PERSISTENT_DAQ_ADAPTERS = adapters;
