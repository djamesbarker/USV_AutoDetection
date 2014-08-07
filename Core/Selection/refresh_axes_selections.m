function refresh_axes_selections(ax)

if ~is_selection_axes(ax)
	error('Input is not selection axes.');
end

[sel, opt] = get_axes_selections(ax); 

set_axes_selections(ax, sel, opt);
