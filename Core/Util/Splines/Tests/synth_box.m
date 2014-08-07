function [x freq amp] = synth_box(t, freq, amp, fs)

close all

dur = diff(t); n_samples = dur*fs; n_points = length(freq)-2;

p = linspace(0, n_points - 1, n_samples);

w_f = bspline_weights(freq);
w_a = bspline_weights(amp);

freq = eval_bspline(p, w_f);
amp = eval_bspline(p, w_a);

x = cos(2*pi*freq.*linspace(t(1), t(2), n_samples));



figure; plot(freq)
figure; spectrogram(x, 512, 500, [],[],'yaxis')
