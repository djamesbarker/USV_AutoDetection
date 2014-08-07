function X = get_source_samples(ext, context);

if ~isempty(ext.fun.parameter.compile)
	try
		ext.parameter = ext.fun.parameter.compile(ext.parameter, context);
	catch
		nice_catch(lasterror);
	end
end

if ~isempty(ext.fun.compute)
	try
		X = ext.fun.compute(ext.parameter, context); X = X(:, context.page.channels);
	catch
		nice_catch(lasterror);
	end
end

