function [note, tuning] = freq_to_note(freq, root)

if nargin < 2 || isempty(root)
	root = 440;
end

half_steps = log(freq/root) / log(2^(1/12));

interval = round(half_steps);

tuning = half_steps - interval;

octave = floor(interval / 12) + 3;

interval = mod(interval, 12);

if ~nargout
	
	str = note_str(interval, octave);	
		
	if abs(tuning) > 0.01	
		str = [str, ' ', sint2str(100*tuning)];
	end
	
	disp(str); return;
	
end

note = interval;



function str = sint2str(int)

str = '';

if int > 0
	str = '+';
end

str = [str, int2str(int)];



