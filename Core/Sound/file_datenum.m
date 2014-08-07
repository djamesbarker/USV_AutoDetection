function out = file_datenum(file, pat)

if nargin < 2
	pat = 'yyyymmdd_HHMMSS';
end

out = [];

%--- MSP 20120917

len_fn = numel(file);

len_pat = numel(pat);

%---


%--
% turn pattern into regular expression
%--

reg_pat = pat;

for dig = 'ymdHMS'
	reg_pat = strrep(reg_pat, dig, '\d');
end

reg_pat = strrep(reg_pat, '\\', '\');

%--
% find starting index of pattern in file name
%--

ix = regexp(file, reg_pat);


%--- MSP 20120917 - check for ISO 8601 date format

if isempty(ix)
  
  reg_pat = strrep(reg_pat, '_', 'T');

  ix = regexp(file, reg_pat);
  
  if isempty(ix)

    return;

  end
  
end

% if isempty(ix)
%   return;
% end

%--- end MSP



%--
% get actual pattern string and use it with datenum
%--

str = file(ix:ix + numel(pat) - 1);

pat(regexp(pat, '[^ymdHMS]')) = '';

str(regexp(str, '\D')) = '';

out = datenum(str, pat);



%--- MSP 20120917 - add fractional seconds if extended date format

if len_fn > ix + len_pat  ...
&& strcmp(file(ix + len_pat), '_')

  [~, file_trim, ~] = fileparts(file);

  str_ext = file_trim(ix + len_pat + 1:end);

  if all(isstrprop(str_ext,'digit'))
    
    frac_sec = str2double(['0.', str_ext]);
    
    frac_day = frac_sec / 86400;

    out = out + frac_day;

  end
  
end

%--- end MSP
