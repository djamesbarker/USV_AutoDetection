function time = sunbase(event, lon, lat, cal, zen)

% sunbase - compute rise or set time for sun
% -------------------------------------------
%
% time = sunbase(event, lon, lat, cal, zen)
%
% Input:
% ------
%  event - 'rise' or 'set'
%  lon - longitude
%  lat - latitude
%  cal - date as [year, month, day] 
%  zen - zenith or 'official', 'civil', 'nautical', or 'astronomical'
%
% Output:
% -------
%  time - of event
%
% NOTE: this adapts the algorithm at http://williams.best.vwh.net/sunrise_sunset_algorithm.htm

% NOTE: that the described algorithm uses degrees throughout, in MATLAB we use the 'd' trigonometric functions

% TODO: currently 'dawn' and 'dusk' calculations are the same as 'rise' and 'set'

%----------------------
% HANDLE INPUT
%----------------------

%--
% set zenith angle, possibly to conventional value
%--

% NOTE: using 'civil' we get 'dawn' and 'dusk', consider coordinating with 'input'

if nargin < 5
	zen = 'official';
end

if ischar(zen)
	
	switch zen	
		case 'official', zen = 90 + 50/60;
			
		case 'civil', zen = 96;
			
		case 'nautical', zen = 102;
			
		case 'astronomical', zen = 108;	
	end
end

%--
% get date
%--

if nargin < 4
	cal = clock; 
end

year = cal(1); month = cal(2); day = cal(3);

%--
% set location, ithaca
%--

if nargin < 3
	lon = -76.5034; lat = 42.4439;
end

%----------------------
% COMPUTE
%----------------------

%--
% first calculate the day of the year
%--

N1 = floor(275 * month / 9);

N2 = floor((month + 9) / 12);

N3 = (1 + floor((year - 4 * floor(year / 4) + 2) / 3));

N = N1 - (N2 * N3) + day - 30;

%--
% convert the longitude to hour value and calculate an approximate time
%--

lngHour = lon / 15;

switch event
	case 'dawn'
		t = N + ((6 - lngHour) / 24);
		
	case 'rise'
		t = N + ((6 - lngHour) / 24);

	case 'set'
		t = N + ((18 - lngHour) / 24);
		
	case 'dusk'
		t = N + ((18 - lngHour) / 24);
end

%--
% calculate the Sun's mean anomaly, true longitude, and right ascension
%--

M = (0.9856 * t) - 3.289;
	
% NOTE: L potentially needs to be adjusted into the range [0,360) by adding/subtracting 360
	
L = M + (1.916 * sind(M)) + (0.020 * sind(2 * M)) + 282.634; % L = mod(L, 360);
	
% NOTE: RA potentially needs to be adjusted into the range [0,360) by adding/subtracting 360

RA = atand(0.91764 * tand(L)); % RA = mod(RA, 360);

% NOTE: right ascension value needs to be in the same quadrant as L

Lquadrant  = (floor(L/90)) * 90; RAquadrant = (floor(RA/90)) * 90;

RA = RA + (Lquadrant - RAquadrant);

% NOTE: right ascension value needs to be converted into hours

RA = RA / 15;

%--
% calculate the Sun's declination
%--

sinDec = 0.39782 * sind(L);

cosDec = cosd(asind(sinDec));

% NOTE: calculate the Sun's local hour angle

cosH = (cosd(zen) - (sinDec * sind(lat))) / (cosDec * cosd(lat));

% TODO: the logic below may not apply to the 'dawn' and 'dusk' events!

% NOTE: the sun never rises on this location (on the specified date)

if (cosH >  1) && (strcmp(event, 'dawn') || strcmp(event, 'rise'))
	time = []; return; 
end

% NOTE: the sun never sets on this location (on the specified date)

if (cosH < -1) && (strcmp(event, 'set') || strcmp(event, 'dusk'))
	time = []; return;
end

%--
% finish calculating H and convert into hours
%--

switch event
	case 'dawn'
	  H = 360 - acosd(cosH);
	  
	case 'rise'
	  H = 360 - acosd(cosH);
	  
	case 'set'
	  H = acosd(cosH);
	  
	case 'dusk'
	  H = acosd(cosH);
end

H = H / 15;

%--
% calculate local mean time of rising/setting
%--

T = H + RA - (0.06571 * t) - 6.622;

%--
% adjust back to UTC
%--

% NOTE: UT potentially needs to be adjusted into the range [0,24) by adding/subtracting 24

UT = T - lngHour; UT = mod(UT, 24);

%--
% convert UT value to local time zone of latitude/longitude
%--

% TODO: consider the sign of the UTC offset function

time = UT - get_utc_offset; time = mod(time, 24);

