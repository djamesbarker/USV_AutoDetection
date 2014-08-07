function S = event_info_str(name, event, data, fields)

% event_info_str - create string cell array with event info
% ---------------------------------------------------------
%
% S = event_info_str(name, event, data, fields)
%
% Input:
% ------
%  name - name of log
%  event - event to get info from
%  data - parent browser state
%  fields - event fields to display
%
% Output:
% -------
%  S - cell array of info strings

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
% $Revision: 1982 $
% $Date: 2005-10-24 11:59:36 -0400 (Mon, 24 Oct 2005) $
%--------------------------------

% NOTE: this is a kind of serialization enable a simple string output

%--
% set default fields if needed
%--

if (nargin < 4) || isempty(fields)
	
	fields = { ...
		'level', ...
		'score', ...
		'channel', ...
		'time-duration', ...
		'freq-bandwidth', ...
		'created', ...
		'modified' ...
	};

end

%--
% get relevant data from browser state or from sound
%--

try
	sound = data.browser.sound; grid = data.browser.grid;
catch
	sound = data; grid = sound.view.grid;
end

%-----------------------------------------------------
% CREATE INFO STRING CELL
%-----------------------------------------------------

%--
% compute event labels
%--

% NOTE: not all of these may be used

opt = event_labels;

opt.time = data.browser.grid.time.labels;

opt.freq = data.browser.grid.freq.labels;

[time, freq] = selection_labels([], event, data);

%----------------------------
% NAME
%----------------------------

S = {['Event:  ', event_name(event, name)]}; 

%----------------------------
% OTHER FIELDS
%----------------------------

for k = 1:length(fields)
	
	%--
	% skip non field fields
	%--
	
	if (~isfield(event, fields{k}) && ...
		~strcmpi(fields{k}, 'time-duration') && ...
		~strcmpi(fields{k}, 'freq-bandwidth') ...
	)
		continue;
	end
	
	%--
	% create label section of string
	%--
	
	% TODO: implement some kind of 'alias' mechanism to change the field names
	
	str = [title_caps(fields{k},'_'), ':  '];
	
	%--
	% switch on specific fields
	%--

	switch fields{k}

		case 'channel'

			S{end + 1} = [str, int2str(event.channel)]; 

		case 'score'
			
			if isempty(event.score)
				event.score = nan;
			end
			
			S{end + 1} = [str, num2str(round(1000 * event.score) / 10), '%'];
			
		case 'rating'
			
			% NOTE: this is not implemented yet, this will support a manual 5 point scale
			
			rating = ' ';
			
			for k = 0:event.rating
				rating = [rating, '* '];
			end
			
			S{end + 1} = [str, rating];
			
		case 'level'
			
			% NOTE: omit this for simple events
			
			if event.level > 1
				S{end + 1} = [str, int2str(event.level)]; 
			end

		case 'time'

			S{end + 1} = ['Time:  ', time{1}, ' - ' time{2}];

		case 'duration'

			S{end + 1} = [str, time{3}];
			
		case 'time-duration'
			
			S{end + 1} = ['Time:  ', time{1}, ' - ' time{2}, '  (', time{3}, ')'];

		case 'freq'

			% TODO: remove units from first frequency
			
			S{end + 1} = ['Freq:  ', freq{1}, ' - ', freq{2}];

		case 'bandwidth'

			S{end + 1} = [str, freq{3}];
			
		case 'freq-bandwidth'
			
			S{end + 1} = ['Freq:  ', freq{1}, ' - ', freq{2}, '  (', freq{3}, ')'];

		% NOTE: we display either creation or modification date
		
		case 'created'
			
			if isempty(event.modified)
				S{end + 1} = [str, datestr(event.created)];
			end
			
		case 'modified'

			if ~isempty(event.modified)
				S{end + 1} = [str, datestr(event.modified)];
			end

		otherwise
	
			% NOTE: we only display other fields when they are empty
			
			% TODO: implement non-empty display of other fields
			
			if isempty(event.(fields{k}))
				S{end + 1} = [str, '(Not Available)'];
			end

	end
		
end
	
