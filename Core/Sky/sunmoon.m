function times = sunmoon(lon, lat, cal, tz, event)

% sunmoon - computes sun and moon rise, set, and twilight events
% --------------------------------------------------------------
% events = sunmoon(lon, lat, cal, tz)
%
% Input:
% ------
% lat, lon - latitude and longitude, defaults to Ithaca
% cal - date as [year, month, day]
% tz - time zone as offset from UTC
% event - one of 'civil', 'nautical', or 'astronomical', default is civil
%
% Output:
% -------
% events - result structure
%
% NOTE: this is a direct translation of a set of routines from,
%  Montenbruck and Pfleger's
%  Astronomy on the Computer 2nd English ed
% (see chapter 3.8 the sunset program)
%

%--
% handle input
%--

% NOTE: default dawn and dusk are 'civil' twilight

if nargin < 5
    event = 'civil';
end

% NOTE: we obtain the UTC offset and the current time from the system

if nargin < 4
    tz = -1 * get_utc_offset;
end

if nargin < 3
    cal = clock;
end

if nargin < 2
    % NOTE: the default location, Ithaca
    
    lon = -76.5034; lat = 42.4439;
end

%--
% compute sun and moon events
%--

y = cal(1); m = cal(2); d = cal(3);

% Find Modified Julian Day

mj = greg2mjd(d, m, y, 0.0);

% Find all sun events

[times.sun.rise, times.sun.set] = find_sun_and_twi_events_for_date(mj, tz, lon, lat, sind(-0.833));

switch event
    case 'nautical'
        [times.sun.dawn, times.sun.dusk] = find_sun_and_twi_events_for_date(mj, tz, lon, lat, sind(-12.0));
        
    case 'astronomical'
        [times.sun.dawn, times.sun.dusk] = find_sun_and_twi_events_for_date(mj, tz, lon, lat, sind(-18.0));
        
    otherwise % default is civil twilight
        [times.sun.dawn, times.sun.dusk] = find_sun_and_twi_events_for_date(mj, tz, lon, lat, sind(-6.0));
end

% Find moon events

[times.moon.rise, times.moon.set] = find_moonrise_set(mj, tz, lon, lat);

%
%  Returns an angle in degrees in the range 0 to 360
%
function a = range(x)
b = x / 360;
a = 360 * (b - (fix(b)));
if (a < 0 )
    a = a + 360;
end

%
%  Finds the parabola through the three points (-1,ym), (0,yz), (1, yp)
%  and returns the coordinates of the max/min (if any) xe, ye
%  the values of x where the parabola crosses zero (roots of the quadratic)
%  and the number of roots (0, 1 or 2) within the interval [-1, 1]
%
%  results passed as array [nz, z1, z2, xe, ye]
%
function [nz, z1, z2, xe, ye] = quad(ym, yz, yp)
nz = 0; z1 = 0; z2 = 0;
a = 0.5 * (ym + yp) - yz;
b = 0.5 * (yp - ym);
c = yz;
xe = -b / (2 * a);
ye = (a * xe + b) * xe + c;
dis = b * b - 4.0 * a * c;
if (dis > 0)
    dx = 0.5 * sqrt(dis) / abs(a);
    z1 = xe - dx;
    z2 = xe + dx;
    if abs(z1) <= 1.0
        nz = nz + 1;
    end
    if (abs(z2) <= 1.0)
        nz = nz + 1;
    end
    if (z1 < -1.0)
        z1 = z2;
    end
end

%
%  Takes the mjd and the longitude (west negative) and then returns
%  the local sidereal time in hours. Uses Meeus formula 11.4
%  instead of messing about with UTo and so on
%
function lst = lmst(mjd, glong)
d = mjd - 51544.5;
t = d / 36525.0;
lst = range(280.46061837 + 360.98564736629 * d + 0.000387933 *t*t - t*t*t / 38710000);
lst = lst/15.0 + glong/15;


%
%  Returns the ra and dec of the Sun in an array called suneq[]
%  in decimal hours, degs referred to the equinox of date and using
%  obliquity of the ecliptic at J2000.0 (small error for +- 100 yrs)
%  takes t centuries since J2000.0. Claimed good to 1 arcmin
%
function [ra, dec] = minisun(t)
p2 = 6.283185307;
coseps = 0.91748;
sineps = 0.39778;

M = p2 * frac(0.993133 + 99.997361 * t);
DL = 6893.0 * sin(M) + 72.0 * sin(2 * M);
L = p2 * frac(0.7859453 + M / p2 + (6191.2 * t + DL)/1296000);
SL = sin(L);
X = cos(L);
Y = coseps * SL;
Z = sineps * SL;
RHO = sqrt(1 - Z * Z);
dec = (360.0 / p2) * atan(Z / RHO);
ra = (48.0 / p2) * atan(Y / (X + RHO));
if ra <0
    ra = ra + 24;
end

%
% Takes t and returns the geocentric ra and dec in an array mooneq
% claimed good to 5' (angle) in ra and 1' in dec
% tallies with another approximate method and with ICE for a couple of dates
%
function [ra, dec] = minimoon(t)
p2 = 6.283185307;
arc = 206264.8062;
coseps = 0.91748;
sineps = 0.39778;

L0 = frac(0.606433 + 1336.855225 * t);    % mean longitude of moon
L = p2 * frac(0.374897 + 1325.552410 * t); %mean anomaly of Moon
LS = p2 * frac(0.993133 + 99.997361 * t);  %mean anomaly of Sun
D = p2 * frac(0.827361 + 1236.853086 * t); %difference in longitude of moon and sun
F = p2 * frac(0.259086 + 1342.227825 * t); %mean argument of latitude

% corrections to mean longitude in arcsec
DL =  22640 * sin(L) + ...
    -4586 * sin(L - 2*D) + ...
    2370 * sin(2*D) + ...
    +769 * sin(2*L) + ...
    -668 * sin(LS) + ...
    -412 * sin(2*F) + ...
    -212 * sin(2*L - 2*D) + ...
    -206 * sin(L + LS - 2*D) + ...
    +192 * sin(L + 2*D) + ...
    -165 * sin(LS - 2*D) + ...
    -125 * sin(D) + ...
    -110 * sin(L + LS) + ...
    +148 * sin(L - LS) + ...
    -55 * sin(2*F - 2*D);

% simplified form of the latitude terms
S = F + (DL + 412 * sin(2*F) + 541* sin(LS)) / arc;
H = F - 2*D;
N =   -526 * sin(H) + ...
    +44 * sin(L + H) + ...
    -31 * sin(-L + H) + ...
    -23 * sin(LS + H) + ...
    +11 * sin(-LS + H) + ...
    -25 * sin(-2*L + F) + ...
    +21 * sin(-L + F);

% ecliptic long and lat of Moon in rads
L_moon = p2 * frac(L0 + DL / 1296000);
B_moon = (18520.0 * sin(S) + N) / arc;

% equatorial coord conversion - note fixed obliquity
CB = cos(B_moon);
X = CB * cos(L_moon);
V = CB * sin(L_moon);
W = sin(B_moon);
Y = coseps * V - sineps * W;
Z = sineps * V + coseps * W;
RHO = sqrt(1.0 - Z*Z);
dec = (360.0 / p2) * atan(Z / RHO);
ra = (48.0 / p2) * atan(Y / (X + RHO));
if ra <0
    ra = ra + 24;
end
%
%  This rather mickey mouse function takes a lot of
%  arguments and then returns the sine of the altitude of
%  the object labelled by iobj. iobj = 1 is moon, iobj = 2 is sun
%
function salt = sin_alt(iobj, mjd0, hour, glong, cglat, sglat)

mjd = mjd0 + hour/24.0;
t = (mjd - 51544.5) / 36525.0;
if iobj == 1
    [ra, dec] = minimoon(t);
else
    [ra, dec] = minisun(t);
end
% hour angle of object
tau = 15.0 * (lmst(mjd, glong) - ra);
% sin(alt) of object using the conversion formulas
salt = sglat * sind(dec) + cglat * cosd(dec) * cosd(tau);

%
% Find all sun events
%
function [utrise, utset] = find_sun_and_twi_events_for_date(mjd, tz, glong, glat, sinho)
%
%    Set up the array with the 4 values of sinho needed for the 4
%      kinds of sun event
%
sglat = sind(glat);
cglat = cosd(glat);
date = mjd - tz/24;
%
%    main loop takes each value of sinho in turn and finds the rise/set
%      events associated with that altitude of the Sun
%
utrise = -Inf;
utset = -Inf;
above = false;
hour = 1.0;
ym = sin_alt(2, date, hour - 1.0, glong, cglat, sglat) - sinho;
if ym > 0.0
    above = true;
end
%
% the while loop finds the sin(alt) for sets of three consecutive
% hours, and then tests for a single zero crossing in the interval
% or for two zero crossings in an interval or for a grazing event
%
while(hour < 25 && (utset == -Inf || utrise == -Inf))
    yz = sin_alt(2, date, hour, glong, cglat, sglat) - sinho;
    yp = sin_alt(2, date, hour + 1.0, glong, cglat, sglat) - sinho;
    [nz, z1, z2, xe, ye] = quad(ym, yz, yp);
    
    % case when one event is found in the interval
    if nz == 1
        if ym < 0.0
            utrise = hour + z1;
        else
            utset = hour + z1;
        end
    end % end of nz = 1 case
    
    % case where two events are found in this interval
    % (rare but whole reason we are not using simple iteration)
    if (nz == 2)
        if (ye < 0.0)
            utrise = hour + z2;
            utset = hour + z1;
        else
            utrise = hour + z1;
            utset = hour + z2;
        end
    end % end of nz = 2 case
    
    % set up the next search interval
    ym = yp;
    hour = hour + 2.0;
    
end% end of while loop

% For no rise or set events, check if alway up or always down
if utset == -Inf && utrise == -Inf
    if above
        utset = Inf;
        utrise = Inf;
    end
end

%
% Find moon rise and set times
%
function [utrise, utset] = find_moonrise_set(mjd, tz, glong, glat)

sinho = sind(8/60);   % Moonrise taken as centre of moon at +8 arcmin
sglat = sind(glat);
cglat = cosd(glat);
date = mjd - tz/24;
utrise = -Inf;
utset = -Inf;
above = false;
hour = 1.0;
ym = sin_alt(1, date, hour - 1.0, glong, cglat, sglat) - sinho;
if ym > 0.0
    above = true;
end
while(hour < 25 && (utset == -Inf || utrise == -Inf))
    yz = sin_alt(1, date, hour, glong, cglat, sglat) - sinho;
    yp = sin_alt(1, date, hour + 1.0, glong, cglat, sglat) - sinho;
    [nz, z1, z2, xe, ye] = quad(ym, yz, yp);
    
    % case when one event is found in the interval
    if nz == 1
        if ym < 0.0
            utrise = hour + z1;
        else
            utset = hour + z1;
        end
    end% end of nz = 1 case
    
    % case where two events are found in this interval
    % (rare but whole reason we are not using simple iteration)
    if nz == 2
        if ye < 0.0
            utrise = hour + z2;
            utset = hour + z1;
        else
            utrise = hour + z1;
            utset = hour + z2;
        end
    end
    
    % set up the next search interval
    ym = yp;
    hour = hour + 2.0;
    
end

% For no rise or set events, check if alway up or always down
if utset == -Inf && utrise == -Inf
    if above
        utset = Inf;
        utrise = Inf;
    end
end


