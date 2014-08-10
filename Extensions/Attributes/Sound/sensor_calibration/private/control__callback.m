function result = control__callback(callback, context)

% SENSOR_CALIBRATION - control__callback

% Copyright (C) 2002-2012 Cornell University

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

result = struct;

%--
% get calibration from fishbowl
%--

calibration = get_control(callback.pal.handle, 'calibration', 'value');

if isempty(calibration)
    calibration = context.attribute.calibration;
end

%--
% get current channel index
%--

channel = get_control(callback.pal.handle, 'channel', 'index');

switch callback.control.name
    
    case 'channel'
        
        set_control(callback.pal.handle, 'offset', 'value', calibration(channel));
        
    case 'offset'
        
        %--
        % modify value for channel
        %--

        calibration(channel) = get_control(callback.pal.handle, 'offset', 'value');
        
        %--
        % store the result
        %--
        
        set_control(callback.pal.handle, 'calibration', 'value', calibration);
           
end

result.calibration = calibration;

result.reference = get_control(callback.pal.handle, 'reference', 'value') * 10^-6;


        
