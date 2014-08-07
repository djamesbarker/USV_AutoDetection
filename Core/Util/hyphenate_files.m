function hyphenate_files(varargin)

files = ls(varargin{:});

for k = 1:size(files, 1)
	
	filek = files(k,:);
	
	if strmatch(filek, '.')
		continue;
	end
	
	try
		movefile(filek, strrep(filek, '_', '-'));
	end
	
end
