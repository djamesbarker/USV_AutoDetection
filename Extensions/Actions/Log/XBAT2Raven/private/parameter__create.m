function parameter = parameter__create(context)

% XBAT2RAVEN_V33 - parameter__create

parameter = struct;

parameter.scores_flag = 0;

parameter.tags_flag = 0;

parameter.ratings_flag = 0;

parameter.notes_flag = 0;

parameter.datetime_flag = 0;

parameter.realdate_flag = 0;

parameter.realtime_flag = 0;


parameter.datetime_format = 1;


parameter.datetime_format_out = 1;

parameter.realtime_format_out = 1;

parameter.realdate_format_out = 1;


parameter.filetime_flag = 0;

parameter.filetime_flag_end_file = 0;
parameter.filetime_flag_end = 0;

parameter.modify_logs = 0;

%--pitz

parameter.empty_field1 = '';

parameter.empty_field2 = '';

parameter.empty_field3 = '';

parameter.empty_field4 = '';

parameter.empty_field5 = '';

%--

parameter.empty_logs_ok = 0;
