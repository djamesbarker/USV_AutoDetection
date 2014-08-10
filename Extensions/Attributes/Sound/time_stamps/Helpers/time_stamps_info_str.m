function str = time_stamps_info_str(table)

str = {};

for k = 1:size(table, 1)
	
	str{end + 1} = [sec_to_clock(table(k, 1)), ' -> ', sec_to_clock(table(k, 2))];
	
end
