function s = string_singular(s)

if strcmpi(s(end-2:end), 'ies')
	s = [s(1:end-3), 'y']; return;
end

if strcmpi(s(end-1:end), 'es')
	s = s(1:end-2);
end

if s(end) == 's'
	s = s(1:end-1);
end
