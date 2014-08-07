function state = stop_whining(state)

% stop_whining - in buffered player through post-resample filtering
% -----------------------------------------------------------------
%
% state = stop_whining(state)
%
% Input:
% ------
%  state - desired
%
% Output:
% -------
%  state - current
%
% See also: buffered_player

name = 'stop_whining';

if ~nargin
	
	state = get_env(name);
	
	if isempty(state)
		state = set_env(name, false);
	end
else
	switch state
		
		case {true, 'true', 'on'}
			state = set_env(name, true);
			
		case {false, 'false', 'off'}
			state = set_env(name, false);
			
		otherwise
			error('Set whining to ''on'' or ''off''.');
	end	
end
