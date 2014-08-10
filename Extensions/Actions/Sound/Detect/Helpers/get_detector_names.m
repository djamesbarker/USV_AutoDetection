function names = get_detector_names

ext = get_extensions('sound_detector');

if isempty(ext)
	names = {'(No Detectors Found)'};
else
	names = {ext.name};
end
