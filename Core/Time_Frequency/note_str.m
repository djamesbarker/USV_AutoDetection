function str = note_str(interval, octave)

if nargin < 2 
	octave = [];	
end

switch interval
	
	case 0, str = 'A';
		
	case 1, str = 'Bb';
		
	case 2, str = 'B';
		
	case 3, str = 'C';
		
	case 4, str = 'C#';
		
	case 5, str = 'D';
		
	case 6, str = 'Eb';
		
	case 7, str = 'E';
		
	case 8, str = 'F';
		
	case 9, str = 'F#';
		
	case 10, str = 'G';
		
	case 11, str = 'Ab';
		
end

str = [str, int2str(octave)];
