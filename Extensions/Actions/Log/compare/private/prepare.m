function [result, context] = prepare(parameter, context)

% COMPARE - prepare

result = struct;

h = figure;
ax = axes('parent', h);
hold(ax, 'on');

context.figure_handle = h;
context.ax = ax;

context.colormap = jet(numel(context.target));
context.color_ix = 1;
