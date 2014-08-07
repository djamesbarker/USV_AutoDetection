function value = is_vowel(str)

for k = 1:length(str)
	
	value(k) = any((str(k) == 'aeiouAEIOU'));
	
end
