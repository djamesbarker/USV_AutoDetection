function passed = test_sunmoon

% test_sunmoon - Test sun and moon event calculations
% ---------------------------------------------------
% passed = test_sunmoon
%
% Output:
% -------
% passed - boolean
%
% See also: sunmoon

passed = true;

%--
% Tolerance is within one minute
%--

tol = 1/60;

%--
% Test near equator
%--

lat = -0.25; lon = -78.583333; tz = -5; % Quito, Ecuador

cal = [2010, 6, 12, 12, 0, 0];

times = sunmoon(lon, lat, cal, tz, 'nautical');

if abs(times.sun.rise - 6.1833) > tol
    passed = false;
end
if abs(times.sun.set - 18.2833) > tol
    passed = false;
end
if abs(times.sun.dawn - 5.3833) > tol
    passed = false;
end
if abs(times.sun.dusk - 19.1000) > tol
    passed = false;
end
if abs(times.moon.rise - 6.2333) > tol
    passed = false;
end
if abs(times.moon.set - 18.7167) > tol
    passed = false;
end

%--
% Test in mid latitudes
%--

lon = 52.5; lat = -1.91667; tz = 0; % Birminham, UK

cal = [2000, 1, 3, 12, 0, 0];

times = sunmoon(lon, lat, cal, tz, 'astronomical');

if abs(times.sun.rise - 2.4500) > tol
    passed = false;
end
if abs(times.sun.set - 14.6833) > tol
    passed = false;
end
if abs(times.sun.dawn - 1.2000) > tol
    passed = false;
end
if abs(times.sun.dusk - 15.9333) > tol
    passed = false;
end
if times.moon.rise ~= -Inf
    passed = false;
end
if abs(times.moon.set - 12.1167) > tol
    passed = false;
end

%--
% Test inside artic circle
%--

lon = 17.42; lat = 68.43; tz = 1; % Narvik, Norway

cal = [2004, 12, 25, 12, 0, 0];   % Winter

times = sunmoon(lon, lat, cal, tz, 'civil');

if times.sun.rise ~= -Inf
   passed = false;
 disp('Failed artic sunrise');
end
if times.sun.set ~= -Inf
    passed = false;
end
if abs(times.sun.dawn - 9.2872) > tol
    passed = false;
end
if abs(times.sun.dusk - 14.3997) > tol
    passed = false;
end
if times.moon.rise ~= Inf
    passed = false;
end
if times.moon.set ~= Inf
    passed = false;
end

if passed
	disp('PASSED ALL TESTS!');
end


