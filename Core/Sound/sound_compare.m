function [flag,flags] = sound_compare(f,g)

% sound_compare - compare sound structures
% ----------------------------------------
%
% [flag,flags] = sound_compare(f,g,mode)
%
% Input:
% ------
%  f,g - sound structures to compare
%
% Output:
% -------
%  flag - comparison flag
%  flags - detailed comparison

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
% $Revision: 5824 $
% $Date: 2006-07-21 15:52:41 -0400 (Fri, 21 Jul 2006) $
%--------------------------------

% NOTE: this function is very primitive, it is really a simple sanity check

%-------------------------------------------------
% COMPARE RELEVANT FIELDS
%-------------------------------------------------

%--
% check type
%--

flags = ones(1, 5);

if (strcmp(f.type,g.type) == 0)
	flags(1) = 0;
end

%--
% number of files
%--

if (length(f.file) ~= length(g.file))
	flags(2) = 0;
end

%--
% channels
%--

if (f.channels ~= g.channels)
	flags(3) = 0;
end

%--
% samples per file
%--

if (any(f.samples ~= g.samples))
	flags(4) = 0;
end

%--
% rate
%--

if f.samplerate ~= g.samplerate
	flags(5) = 0;
end

flag = all(flags);


% %--
% % bits per sample
% %--
% 
% % NOTE: the 'pcmbitwidth' field has been renamed to 'samplesize'
% 		
% if (isfield(f,'pcmbitwidth'))
% 	f_sample_size = f.pcmbitwidth;
% else
% 	f_sample_size = f.samplesize;
% end
% 
% if (isfield(g,'pcmbitwidth'))
% 	g_sample_size = g.pcmbitwidth;
% else
% 	g_sample_size = g.samplesize;
% end
% 		
% if (f_sample_size ~= g_sample_size)
% 	warn('samplesize');
% 	flag = 0; f = []; return;
% end
% 	
% %-------------------------------------------------
% % OUTPUT MOST RECENT SOUND
% %-------------------------------------------------
% 
% if (nargout > 1)
% 	
% 	if (isempty(f.modified))
% 		f_date = f.created;
% 	else
% 		f_date = f.modified;
% 	end
% 	
% 	if (isempty(g.modified))
% 		g_date = g.created;
% 	else
% 		g_date = g.modified;
% 	end
% 	
% 	if (g_date > f_date)
% 		f = g;
% 	end
% 	
% end
% 		
% %-------------------------------------------------
% % WARN
% %-------------------------------------------------
% 
% function warn(field)
% 
% % warn - display sound difference warning
% % ---------------------------------------
% %
% % warn(field)
% %
% % Input:
% % ------
% %  field - field that is different
% 
% disp(' '); 
% disp(['Sound structures have essentially different ''' field ''' field contents.']);
% disp(' ');
