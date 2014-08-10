function result = parameter__control__callback(callback, context)

% XBAT2RAVEN_V33 - parameter__control__callback

result = struct;


%find state of subdivide control

%%
dt_flag = get_control(callback.pal.handle, 'datetime_flag', 'value');

if dt_flag
     %enable choice for datetime format
%     set_control(callback.pal.handle, 'datetime_format', 'enable', 1);
    set_control(callback.pal.handle, 'datetime_format_out', 'enable', 1);   
else
    %disable choice for datetime format
%     set_control(callback.pal.handle, 'datetime_format', 'enable', 0);
    set_control(callback.pal.handle, 'datetime_format_out', 'enable', 0);
end

%%
rt_flag = get_control(callback.pal.handle, 'realtime_flag', 'value');

if rt_flag
     %enable choice for real time format
    set_control(callback.pal.handle, 'realtime_format_out', 'enable', 1);  
else
    %disable choice for real time format
    set_control(callback.pal.handle, 'realtime_format_out', 'enable', 0);
end

%%
rd_flag = get_control(callback.pal.handle, 'realdate_flag', 'value');

if rd_flag
     %enable choice for real date format
    set_control(callback.pal.handle, 'realdate_format_out', 'enable', 1);  
else
    %disable choice for real date format
    set_control(callback.pal.handle, 'realdate_format_out', 'enable', 0);
end

%%
% if strcmp(dt_flag,'Recalculate real event times and dates using sound name (must select format below)')
%     
%     %enable option to save newly recalculated datetime format
%     set_control(callback.pal.handle, 'modify_logs', 'enable', 1);
% else
%     %disable option to save newly recalculated datetime format
%     set_control(callback.pal.handle, 'modify_logs', 'enable', 0);
% end