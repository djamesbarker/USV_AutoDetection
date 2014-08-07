function [year, month, day, hour] = mjd2greg(mjd)

% mjd2greg - modified julian date to gregorian conversion
% -------------------------------------------------------
%
% [year, month, day, hour] = mjd2greg(mjd)
%
%  Takes mjd and returns the civil calendar date in Gregorian calendar
%  as a string in format yyyymmdd.hhhh
%  looks OK for Greg era dates  - not good for earlier - 26th Dec 02
%
% See also: mjd2greg

jd = mjd + 2400000.5;

jd0 = floor(jd + 0.5);

if jd0 < 2299161.0
	c = jd0 + 1524.0;
else
	b = floor((jd0 - 1867216.25) / 36524.25);
	
	c = jd0 + (b - floor(b/4)) + 1525.0;
end

d = floor((c - 122.1)/365.25);

e = 365.0 * d + floor(d/4);

f = floor((c - e) / 30.6001);

day = floor(c - e + 0.5) - floor(30.6001 * f);

month = f - 1 - 12 * floor(f/14);

year = d - 4715 - floor((7 + month)/10);

hour = 24.0 * (jd + 0.5 - jd0); 

% TODO: this 'hrsmin' is not defined anywhere

hour = hrsmin(hour);
