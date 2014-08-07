function out = plot_colors(N, intensity)

if nargin < 2 || isempty(intensity)
	intensity = 0.8;
end

switch (N)
	
	case (1), colors = [0, 0, 1];
		
	case (2), colors = [0, 0, 1; 0, 1, 0];
		
	otherwise, colors = flipud(hsv(N));
		
end
	
out = intensity * colors;
