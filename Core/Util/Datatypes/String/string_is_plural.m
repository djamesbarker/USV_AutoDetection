function out = string_is_plural(s)

out = 0;

ix = strfind(s, 'ae');

if ix == length(s) - 1
	out = 1; return;
end

if s(end) == 's' || s(end) == 'i'
	out = 1; return;
end

if s(end) == 'a'
	return -1;
end
