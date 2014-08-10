function [log_list, sound_list, ver_status] = list_logs(context)
%
% Returns a list of selected logs, and a list of XBAT sounds the logs are in


ver_status = 0;


%% list names of selected logs

if isfield(context, 'target')   %check if context.target is available
  
  target = context.target;
  
else
  
  fail('API supplied no context.target in prepare.m', 'Software Failure');
  
  ver_status = 1;
  
  return;
  
end

if ~iscell(target)
  
  target = {target};
  
end


NumLogs = length(target);

log_list = cell(NumLogs,1);

sound_list = log_list;


for i = 1:NumLogs
  
  [sound_list{i}, log_list{i}] = fileparts(target{i});
  
  if isempty(sound_list{i}) || isempty(log_list{i})
    
    fail('Error reading selected logs.', 'Software error');
    
    ver_status = 1;
    
    return;
    
  end
    
end

