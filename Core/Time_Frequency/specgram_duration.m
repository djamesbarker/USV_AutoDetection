function duration = specgram_duration(opt, rate, duration)

time_res = specgram_resolution(opt, rate);

hop_samples = (opt.fft - round((1 - opt.hop) * opt.fft));

duration = ((duration / time_res) * hop_samples * opt.sum_length + opt.fft) / rate;
