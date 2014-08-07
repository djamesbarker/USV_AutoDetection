function time = moonrise(varargin)

% moonrise - time on given date and location
% --------------------------------------
%
% time = moonrise(lon, lat, cal, tz)
%
% Input:
% ------
%  lon - longitude
%  lat - latitude
%  cal - date as [year, month, day] 
%  tz - offset from UTC
%
% Output:
% -------
%  time - of moonrise
%
% See also: sunrise, sunset, dusk, dawn, moonset, sunmoon
%
% NOTE: this is just a convenience function calling 'sunmoon'

% time = sunbase('dawn', varargin{:});

events = sunmoon(varargin{:});

time = events.moon.rise;

if ~nargout
	disp(' '); disp(sec_to_clock(3600 * time)); disp(' '); clear time;
end
