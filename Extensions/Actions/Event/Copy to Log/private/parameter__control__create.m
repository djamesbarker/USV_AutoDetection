function control = parameter__control__create(parameter, context)

% COPY TO LOG - parameter__control__create

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

control = empty(control_create);

%--
% get browser for context
%--

try
    par = context.callback.par.handle;
catch
    par = [];
end
      
if isempty(par)
    par = get_active_browser;
end

%--
% get log_name(s) that we can't copy to
%--

if iscell(context.target)
    
    event_log_name = cell(1, length(context.target));
    
    for k = 1:length(context.target)
        
        [ignore, event_log_name{k}] = get_str_event(par, context.target{k}); 
        
    end
    
else

    [event, event_log_name] = get_str_event(par, context.target); 

end

%--
% get list of logs names that the event(s) can be copied to
%--

log_names = setdiff(log_name(get_browser(par, 'log')), event_log_name);

if isempty(log_names)
    log_names = '(No Logs Available)';
end

%--
% create control
%--

control(end + 1) = control_create( ...
    'style', 'popup', ...
    'name', 'log', ...
    'alias', 'destination', ...
    'string', log_names, ...
    'value',1 ...
);
