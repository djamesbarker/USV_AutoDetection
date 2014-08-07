function value = type(obj)

% type - get function handle type
% -------------------------------
%
% type(fun) 
%
% Input:
% ------
%  fun - handle

info = functions(obj); value = info.type;
