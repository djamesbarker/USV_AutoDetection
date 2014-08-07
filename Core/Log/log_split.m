function Y = log_split(X,field,n)

% log_split - partition log in various ways
% -----------------------------------------
%
% logs = log_split(log,field)
%      = log_split(log,'size',n)
%
% Input:
% ------
%  log - input log
%  field - event field used for partition
%  n - maximum number of events in each log part
%
% Output:
% -------
%  logs - log array of partition

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

switch (nargin)
	
%------------------------------------------
% EVENT FIELD CATEGORY PARTITION
%------------------------------------------

case (2)
	
	%--------------------------------
	% get specified field values
	%--------------------------------
	
	if (isfield(X.event,field))
		
		F = struct_field(X.event,field);
		
	else
		
		disp(' ');
		error(['Input partition field ''' field ''' is not an event field.']);
		
	end
	
	%--------------------------------
	% get unique values of field
	%--------------------------------
	
	% note that the results are sorted
	
	G = unique(F);
	
	%--------------------------------
	% check for special partitions
	%--------------------------------
	
	n = length(G);
	
	if (n == length(F))
		
		disp(' '); 
		error(['Partition field ''' field ''' creates full partition, none computed.']);
		
	elseif (n == 1)
		
		disp(' '); 
		warning(['Partition field ''' field ''' does not partition log.']);
		
		Y = X;
		
		return;
		
	end
	
	%--------------------------------
	% create split log filenames
	%--------------------------------
	
	%--
	% create zero-padded integers
	%--
	
	sx = int2str((1:n)');
	
	sx(find(sx == ' ')) = '0';
	
	%--
	% create log filenames
	%--
	
	tmp = findstr(X.file,'.');
	tmp = X.file(1:tmp(end) - 1);
	
	for k = 1:n
		file{k} = [tmp '_' field '_' sx(k,:) '.mat'];
	end
		
	%--------------------------------
	% create partition
	%--------------------------------
	
	Z = X; 
	Z.event = [];
	
	if (iscell(G))
		
		for k = 1:length(G)	
			
			%--
			% find events in part
			%--
			
			ix = struct_find(X.event,field,G{k});
			event = X.event(ix);
			
			%--
			% copy log and update fields
			%--
			
			Y(k,1) = Z;
			
			Y(k,1).file = file{k};
			
			Y(k,1).event = event;
			Y(k,1).length = length(event);
			
			Y(k,1).created = datestr(now);
			Y(k,1).modified = '';
			
			%--
			% save split log
			%--
			
			log_save(Y(k,1));
			
		end
		
	% values in array
	
	else
		
		for k = 1:length(G)	
			
			%--
			% find events in part
			%--
			
			ix = struct_find(X.event,field,G(k,:));
			event = X.event(ix);
			
			%--
			% copy log and update fields
			%--
			
			Y(k,1) = Z;
	
			Y(k,1).file = file{k};
			
			Y(k,1).event = event;
			Y(k,1).length = length(event);
			
			Y(k,1).created = datestr(now);
			Y(k,1).modified = '';
			
			%--
			% save split log
			%--
			
			log_save(Y(k,1));
			
		end
		
	end
	
%--
% size partition
%--

case (3)
	
	%--
	% compute number of parts
	%--
	
	N = length(X.event);
	
	p = floor(N / n);
	
	r = N - (n * p);
	if (r)
		p = p + 1;
	end
	
	%--
	% create split log filenames
	%--
	
	% create zero-padded integers
	
	sx = int2str((1:p)');
	sx(find(sx == ' ')) = '0';
	
	% create log filenames
	
	tmp = findstr(X.file,'.');
	tmp = X.file(1:tmp(end) - 1);
	
	for k = 1:p
		file{k} = [tmp '_' sx(k,:) '.mat'];
	end
	
	%--
	% split log into parts
	%--

	Z = X; 
	Z.event = [];

	for k = 1:p
		
		%--
		% get chunk of events
		%--
		
		if (k < p)
			event = X.event((1 + (k - 1)*n):(k*n));
		else
			event = X.event((1 + (k - 1)*n):end);
		end
		
		%--
		% copy log and update fields
		%--
		
		Y(k,1) = Z;
		
		Y(k,1).file = file{k};
		
		Y(k,1).event = event;
		Y(k,1).length = length(event);
		
		Y(k,1).created = datestr(now);
		Y(k,1).modified = '';
		
		%--
		% save split log
		%--
		
		log_save(Y(k,1));
		
	end

end
