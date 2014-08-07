function sec = time_to_seconds(str)

sec = 0;

while (~isempty(str))
	
	[value,str] = strtok(str); [units,str] = strtok(str);
		
	switch (units(1:3))
		
		case ('sec'), sec = sec + str2num(value);
			
		case ('min'), sec = sec + 60*str2num(value);
			
	end
	
end
