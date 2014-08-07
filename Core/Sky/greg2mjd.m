function mjd = greg2mjd(day, month, year, hour)

% greg2mjd - gregorian to modified julian date conversion
% -------------------------------------------------------
%
%  mjd = greg2mjd(day, month, year, hour)
%
%  Takes the day, month, year and hours in the day and returns the
%  modified julian day number defined as mjd = jd - 2400000.5
%  checked OK for Gregorian era dates - 26th Dec 02
%
% See also: mjd2greg

if month <= 2
	month = month + 12; year = year - 1;
end

a = 10000.0 * year + 100.0 * month + day;

if a <= 15821004.1
	b = -2 * floor((year + 4716)/4) - 1179;
else
	b = floor(year/400) - floor(year/100) + floor(year/4);
end

a = 365.0 * year - 679004.0;

mjd = a + b + floor(30.6001 * (month + 1)) + day + hour/24.0;
