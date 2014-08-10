function sec = file_times_from_names(name, pat0)

% file_times_from_names - get file times from specially encoded file names
% ------------------------------------------------------------------------
%
% time = file_times_from_names(name)
%
% Input:
% ------
%  name - single name string or cell array of strings
%  
% Output:
% -------
%  time - time (in seconds) of file start times

% Copyright (C) 2002-2007 Harold K. Figueroa (hkf1@cornell.edu)
% Copyright (C) 2005-2007 Matthew E. Robbins (mer34@cornell.edu)
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

    
%--- MSP 20120915
%
% original code goes through MATLAB datenum, which leaves a bad rounding
% error, which results in the insertion of many erroneous lines in 
% the date time table
    
    
%--
% set default pattern if none given
%--

if nargin < 2
	pat0 = 'yyyymmdd_HHMMSS';
end

%--
% handle cell array input
%--

sec = [];

if iscell(name)

  len = numel(name);

  sec = zeros(1,len);

  days = sec;
  
	
  for k = 1:numel(name)

    %--
    % turn pattern into regular expression
    %--
    
    fn = name{k};
    
    len_fn = length(fn);
    
    pat = pat0;
    
    len_pat = length(pat);

    reg_pat = pat;

    for dig = 'ymdHMS'
      reg_pat = strrep(reg_pat, dig, '\d');
    end

    reg_pat = strrep(reg_pat, '\\', '\');

    %--
    % find starting index of pattern in file name
    %--

    ix = regexp(fn, reg_pat);


    %--- MSP 20120917 - check for ISO 8601 date format

    if isempty(ix)

      reg_pat = strrep(reg_pat, '_', 'T');

      ix = regexp(fn, reg_pat);

      if isempty(ix)

        return;

      end

    end

    %--
    % calculate time since midnight in seconds
    %--

    str = fn(ix:ix + numel(pat) - 1);

    pat(regexp(pat, '[^ymdHMS]')) = '';

    str(regexp(str, '\D')) = '';

    HH = str2double(str(regexp(pat, 'H')));

    MM = str2double(str(regexp(pat, 'M')));

    SS = str2double(str(regexp(pat, 'S')));


    %--- MSP 20120917 - add fractional seconds if extended date format
    
    if len_fn > ix + len_pat  ...
    && strcmp(fn(ix + len_pat), '_')
    
      str_ext = fn(ix + len_pat + 1:end);
    
      if all(isstrprop(str_ext,'digit'))
        
        frac_sec = str2double(['0.', str_ext]);
        
        SS = SS + frac_sec;
    
      end
      
    end
    

    sec(k) = SS + 60 * MM + 3600 * HH;


    %--
    % calculate datenum of whole day

    days(k) = floor(datenum(str, pat));
		
  end
  
	
	%--
	% subtract off minimum time
	%--
  
  [first_day, idx] = min(days);
	
	days = days - first_day;
  
  sec = sec - sec(idx);
  
  sec = sec + days .* 86400;
	
	return;
	
end








