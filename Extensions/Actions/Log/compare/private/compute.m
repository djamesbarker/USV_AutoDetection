function [result, context] = compute(log, parameter, context)

% COMPARE - compute

result = struct;

ref = get_library_logs('logs', [], [], parameter.reference_log{1});

[true, false] = log_roc(ref, log, linspace(parameter.low_score, parameter.high_score, parameter.n_points));

plot(context.ax, false, true, 'x:', 'Color', context.colormap(context.color_ix,:));

context.color_ix = context.color_ix + 1;
