function [result, context] = compute(event, parameter, context)

% COPY TO LOG - compute

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

log = get_library_logs('logs', context.library, context.sound, parameter.log{1});

%--
% append events to log
%--

log = log_append(log, event);

%--
% save the log
%--

log_save(log);

try
    par = context.callback.par.handle;
catch
    par = get_active_browser;
end

%--
% change log in browser if necessary
%--

if log_is_open(log, par)
    
    names = log_name(get_browser(par, 'log'));
    
    ix = find(strcmp(names, log_name(log)));
    
    %--
    % set browser log
    %--
    
    data = get_browser(par); 
    
    data.browser.log(ix) = log; 
    
    set(par, 'userdata', data);
    
    %--
    % redraw event palette
    %--
  
    pal = get_palette(par, 'Event');
    
    if ~isempty(pal)
        control_callback([], pal, 'find_events');     
    end
    
end
