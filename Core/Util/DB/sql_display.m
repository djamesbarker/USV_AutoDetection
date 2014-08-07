function sql_display(lines)

disp(' ') 

if ischar(lines)
	disp(['  ', lines]);
else
	for k = 1:length(lines)
		disp(['  ', lines{k}]);
	end
end

disp(' '); 
