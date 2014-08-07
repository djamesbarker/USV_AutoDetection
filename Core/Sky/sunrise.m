function time = sunrise(varargin)

% time = sunrise(lon, lat, cal)
%
% Input:
% ------
%  lon - longitude
%  lat - latitude
%  cal - date
%
% Output:
% -------
%  time - of sunrise
%
%  NOTE: Special time value of Inf indicates sun always up, i. e. polar summer,
%  and -Inf indicates sun aways down, i. e. polar winter.
%

events = sunmoon(varargin{:});

time = events.sun.rise;

if ~nargout
	disp(' '); disp(sec_to_clock(3600 * time)); disp(' '); clear time;
end
