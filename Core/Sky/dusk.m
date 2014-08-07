function time = dusk(varargin)

% dusk - time on given date and location
% --------------------------------------
%
% time = dusk(lon, lat, cal, tz)
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
%  time - of dusk
%
% See also: dawn, sunrise, sunset, sunmoon
%
% NOTE: this is just a convenience function calling 'sunmoon'

% time = sunbase('dusk', varargin{:});

events = sunmoon(varargin{:});

time = events.sun.dusk;

if ~nargout
	disp(' '); disp(sec_to_clock(3600 * time)); disp(' '); clear time;
end
