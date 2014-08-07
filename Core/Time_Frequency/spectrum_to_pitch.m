function pitch = spectrum_to_pitch(spec, nyq, max)

maxix = floor((max / nyq) * numel(spec));

trim_spec = spec(3:maxix);

trim_spec = detrend(trim_spec);

figure; plot(trim_spec);

ceps = pwelch(trim_spec, [], [], numel(spec) * 2);

[pix, val] = fast_peak_valley(ceps, 1);

if pix(1) > 2
	ix = pix(1);
else
	ix = pix(2);
end

freq = nyq * 2 / ix;

freq_to_note(freq);

