function get_build_libs

url = ['http://xbat.org/downloads/libs/', computer, '.zip'];
	
try
	curl_get(url, fullfile(xbat_root, 'Core', 'Build', 'LIBS', 'LIBS.zip'));
catch
	nice_catch(lasterror, ['Pre-compiled build libraries are not available for this platform (', computer, ')']);
end
