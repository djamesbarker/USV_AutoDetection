function out = edit_model_dialog(par, component, context)

nyq = get_sound_rate(context.sound) / 2;

%--------------------------------------
% CREATE CONTROLS
%--------------------------------------

control = empty(control_create);

control(end + 1) = control_create( ...
	'style', 'separator', ...
	'type', 'header', ...
	'min', 1, ...
	'string', 'MODEL' ...
);

control(end + 1) = control_create( ...
	'name','component', ...
	'alias', 'FREQUENCY', ...
	'style','axes', ...
	'color', [1 1 1], ...
	'callback', {@edit_callback, 'start'}, ...
	'value', component, ...
	'space', 0.75, ...
	'onload', 1, ...
	'lines',18 ...
);

control(end + 1) = control_create( ...
	'name', 'fix_ends', ...
	'style', 'checkbox', ...
	'value', 1, ...
	'space', -0.9, ...
	'lines', 1 ...
);

% HACK: space and alias are hacked for hidden slider

control(end + 1) = control_create( ...
	'name', 'knot_freq', ...
	'alias', '     knot_freq', ...
	'style', 'slider', ...
	'width', 0.4, ...
	'align', 'right', ...
	'space', 0, ...
	'min', 0, ...
	'value', 0, ...
	'initialstate', '__DISABLE__', ...
	'max', nyq / 1000 ...
);

control(end + 1) = control_create( ...
	'name','amplitude', ...
	'alias', 'AMPLITUDE', ...
	'label', 1, ...
	'style','axes', ...
	'space', 0.75, ...
	'color', [1 1 1], ...
	'lines', 5 ...
);

control(end + 1) = control_create( ...
	'name', 'warp_time', ...
	'style', 'checkbox', ...
	'value', 0, ...
	'lines', 1 ...
);

%--------------------------------------
% CREATE DIALOG
%--------------------------------------

%--
% configure dialog
%--

opt = dialog_group;

opt.width = 18;  opt.left = 1.25; opt.right = 1.25; opt.bottom = 1.5;

%--
% create dialog
%--

out = dialog_group('Edit', control, opt, {@dialog_callback, context}, par);


%-----------------------------
% DIALOG_CALLBACK
%-----------------------------

function result = dialog_callback(obj, eventdata, context)

%--
% set default output and get callback context
%--

result = [];

callback = get_callback_context(obj, 'pack');

%--
% perform control callback
%--

switch (callback.control.name)
	
	case ('component')
		
		% HACK: hide 'knot_freq' slider
		
		temp = findobj(callback.pal.handle, ...
			'type','uicontrol', ...
			'style','slider', ...
			'tag','knot_freq' ...
		);
	
		set(temp, ...
			'visible', 'off', ...
			'hittest', 'off' ...
		);
		
		component = get_control(callback.pal.handle, 'component', 'value');
		
		edit_callback(obj, [], 'start', component, context);
		
	case ('fix_ends')

		% NOTE: consider some kind of guide display
		
	case ('knot_freq')
		
		%--
		% find selected knot and get position
		%--
		
		knot = findobj(callback.pal.handle, 'tag', 'SELECTED_KNOT');
		
		if isempty(knot)
			return;
		end
		
		x = get(knot, 'xdata'); y = get(knot, 'ydata');
		
		x = x(1); y = y(1);
		
		%--
		% get control values
		%--
		
		slider_sync(callback.obj);
		
		value = get_control(callback.pal.handle, 'knot_freq', 'value');
		
		%--
		% move selected knot using callback
		%--
		
		y = linspace(y, value, 5 * round(abs(value - y)));
		
		component = get_control(callback.pal.handle, 'component', 'value');
		
		for k = 1:length(y)
			edit_callback(obj, [], 'move', component, context, 1, [x, y(k)]); drawnow;
		end
		
		edit_callback(obj, [], 'move', component, context, 1, [x, y(end)]);
		
		edit_callback(obj, [], 'stop', component, context, 1, [x, y(end)]);
		
	case ('play')
		
		% NOTE: this branch will use context
				
end


%----------------------------------------------------------------
% EDIT_CALLBACK
%----------------------------------------------------------------

function result = edit_callback(obj, eventdata, mode, component, context, A, p)

%-------------------------------
% HANDLE INPUT
%-------------------------------

%--
% set default amplification
%--

if nargin < 6 || isempty(A)
	A = 1;
end

%-------------------------------
% SETUP
%-------------------------------

%--
% set edit mode for spline
%--

editmode = 'xy';

%--
% get parent and axes
%--

pal = ancestor(obj, 'figure'); 

% NOTE: there should be a way of getting rid of this findobj

ax = findobj('tag', 'component', 'type', 'axes');

ax2 = findobj('parent', pal, 'tag', 'amplitude', 'type', 'axes');

%--
% get current point in axes if needed
%--

if (nargin < 7)
	p = get(ax, 'CurrentPoint'); p = p(1, 1:2);
end

xlim = get(ax, 'xlim'); ylim = get(ax, 'ylim');

p = enforce_range(p, xlim, ylim);

%--
% declare persistent value stores
%--

persistent COLOR_TABLE;

persistent KNOTS_LINE MODEL_LINE PHANTOM_1 PHANTOM_2 AMPLITUDE_LINE;

persistent SELECTED_KNOT FREQUENCY_RULE TIME_RULE TIME_TEXT FREQ_TEXT CROSSHAIR_TEXT;

persistent FIX_ENDS WARP_TIME;

%--
% compute according to mode
%--

switch (mode)
    
	%-------------------------
	% START
	%-------------------------
	
    case ('start')
        
		%-------------------------
		% INITIALIZE
		%-------------------------
		
		%--
		% initialize display
		%--
		
		if initialize_display(obj, component, context)
			set(ax, 'buttondownfcn', []); return;
		end
		
		%--
		% get color table
		%--
		
		COLOR_TABLE = cdss_display_colors;

		%-------------------------
		% MODEL HANDLES
		%-------------------------

		%--
		% children of component axes
		%--
		
		KNOTS_LINE = findobj('parent', ax, 'tag', 'KNOTS_LINE');

		MODEL_LINE = findobj('parent', ax, 'tag', 'MODEL_LINE');

		PHANTOM_1 = findobj('parent', ax, 'tag', 'PHANTOM_1');

		PHANTOM_2 = findobj('parent', ax, 'tag', 'PHANTOM_2');
		
		%--
		% children of amplitude axes
		%--
		
		AMPLITUDE_LINE = findobj('parent', ax2, 'tag', 'AMPLITUDE_LINE');
	
		%-------------------------
		% EDIT STATE
		%-------------------------
		
		FIX_ENDS = get(findobj(pal, 'tag', 'fix_ends'), 'value');

		WARP_TIME = get(findobj(pal, 'tag', 'warp_time'), 'value');
	
		%-------------------------
		% NEAREST KNOT
		%-------------------------
		
		p_knot = nearest_knot(p, ax, KNOTS_LINE);
				
		[time_pos, freq_pos, time_text, freq_text, time_align, freq_align] = crosshairs_data(p_knot(1,:), xlim, ylim);
		
		%-------------------------
		% KNOT CROSSHAIR HANDLES
		%-------------------------
		
		if isempty(SELECTED_KNOT) || ~ishandle(SELECTED_KNOT)
		
			%--
			% crosshair
			%--
			
			FREQUENCY_RULE = line(xlim, [p_knot(1,2) p_knot(1,2)], ...
				'parent', ax, ...
				'color', COLOR_TABLE.dark_gray, ...
				'hittest', 'off', ...
				'linestyle', ':', ...
				'tag', 'FREQUENCY_RULE' ...
			);

			TIME_RULE = line([p_knot(1,1) p_knot(1,1)], ylim, ...
				'parent', ax, ...
				'color', COLOR_TABLE.dark_gray, ...
				'hittest', 'off', ...
				'linestyle', ':', ...
				'tag', 'TIME_RULE' ...
			);	

			TIME_RULE(end + 1) = line([p_knot(1,1) p_knot(1,1)], get(ax2, 'ylim'), ...
				'parent', ax2, ...
				'color', COLOR_TABLE.dark_gray, ...
				'linestyle', ':', ...
				'tag', 'TIME_RULE' ...
			);	

			TIME_TEXT = text(time_pos(1), time_pos(2), time_text , ...
				'verticalalign', time_align, ...
				'clipping','on', ...
				'parent', ax ...
			);

			text_highlight(TIME_TEXT);

			FREQ_TEXT = text(freq_pos(1), freq_pos(2), freq_text , ...
				'horizontalalign', freq_align, ...
				'clipping','on', ...
				'parent', ax ...
			);

			text_highlight(FREQ_TEXT);
			
			%--
			% knot
			%--
			
			prop = get(KNOTS_LINE);
		
			SELECTED_KNOT = line(p_knot(:,1), p_knot(:,2), ...
				'parent', ax, ...
				'hittest', 'off', ...
				'linestyle', 'none', ...
				'marker', prop.Marker, ...
				'markersize', prop.MarkerSize, ...
				'markerfacecolor', prop.Color, ...
				'markeredgecolor', COLOR_TABLE.dark_gray, ...
				'tag', 'SELECTED_KNOT' ...
			);
		
		end
		
		%--
		% knot
		%--

		set(SELECTED_KNOT, 'xdata', p_knot(:, 1), 'ydata', p_knot(:, 2));

		%--
		% crosshair
		%--

		set(FREQUENCY_RULE, 'xdata', xlim, 'ydata', [p_knot(1,2) p_knot(1,2)]);

		set(TIME_RULE(1), 'xdata', [p_knot(1,1) p_knot(1,1)], 'ydata', ylim);	

		set(TIME_RULE(2), 'xdata', [p_knot(1,1) p_knot(1,1)], 'ydata', get(ax2, 'ylim'));	

		set(TIME_TEXT, 'position', [time_pos(1,1), time_pos(1,2)], 'string', time_text, 'verticalalign', time_align);

		set(FREQ_TEXT, 'position', [freq_pos(1,1), freq_pos(1,2)], 'string', freq_text, 'horizontalalign', freq_align);
		
		%--
		% finalize knot crosshair display
		%--
		
		set_control(pal, 'knot_freq', 'enable', 'on');
		
		set_control(pal, 'knot_freq', 'value', p_knot(1,2));
		
		%--
		% set edit callbacks
		%--
		
        set(pal, ...
            'WindowButtonUpFcn', {@edit_callback, 'stop', component, context, A}, ...
			'WindowButtonMotionFcn', {@edit_callback, 'move', component, context, A} ...
		);
 
	%-------------------------
	% MOVE
	%-------------------------
	
    case ('move')
		
		%--
		% find nearest knot and get line data
		%--

		KNOTS_LINE = findobj('parent', ax, 'tag', 'KNOTS_LINE');
	
		xdata = get(KNOTS_LINE, 'xdata'); ydata = get(KNOTS_LINE, 'ydata'); N = length(ydata);
	
		[p_knot, ix, p] = nearest_knot(p, ax, KNOTS_LINE); 
		
		%--
		% turn off x editing if needed
		%--
		
		if FIX_ENDS && (length(ix) == 2) 	
			editmode = 'y';
		end
		
		%--
		% move knot to pointer considering mode constraints
		%--
        
		if strfind(editmode, 'x')
			
			txdata = xdata;
			
			txdata(ix) = p(:,1); 
			
			[t, yp] = spline_eval(ydata, txdata, length(get(MODEL_LINE, 'ydata')), A);
			
			%--
			% enforce functional constraint
			%--
			
			if all(diff(t) > eps)		
				xdata = txdata;
			end
			
		end
		
		if strfind(editmode, 'y')
			ydata(ix) = p(:,2);	
		end
		
        %--
        % reticulate
        %--  

        [t, yp] = spline_eval(ydata, xdata, length(get(MODEL_LINE, 'ydata')), A);
		
        %--
        % update model frequency display
        %--
	
        set(KNOTS_LINE, 'ydata', ydata, 'xdata', xdata);

        set(MODEL_LINE, 'xdata', t, 'ydata', yp);
          
        set(PHANTOM_1, 'ydata', ydata(1:2), 'xdata', xdata(1:2));
            
        set(PHANTOM_2, 'ydata', ydata(end-1:end), 'xdata', xdata(end-1:end));	
		
		%--
		% display selected knot
		%--
		
		set(SELECTED_KNOT, ...
			'xdata', xdata(ix), ...
			'ydata', ydata(ix), ...
			'visible', 'on' ...
		);
			
		% NOTE: only update the control when are editing manually
		
		if (nargin < 7)
			set_control(pal, 'knot_freq', 'value', p(1,2));
		end

		%--
		% update crosshair display
		%--
		
		p = p_knot;
		
		[time_pos, freq_pos, time_text, freq_text, time_align, freq_align] = crosshairs_data(p(1,:), xlim, ylim);
		
		set(FREQUENCY_RULE, 'ydata', [p(1,2), p(1,2)]); 
		
		set(FREQ_TEXT, ...
			'position', freq_pos, ...
			'horizontalalign', freq_align, ...
			'string', freq_text ...
		);
	
		if strfind(editmode, 'x')
		
			set(TIME_RULE, 'xdata', [p(1,1), p(1,1)]);

			time_pos = [p(1,1) + 0.025 * diff(xlim), ylim(2) - 0.025 * diff(ylim)];

			time_text = [num2str(p(1,1)), ' sec'];

			set(TIME_TEXT, ...
				'position', time_pos, ...
				'verticalalign', time_align, ...
				'string', time_text ...
			);
		
		end
	
		%--
		% update model amplitude and display if needed
		%--
		
		if WARP_TIME
			set(AMPLITUDE_LINE, 'xdata', t);
		else
			if ~FIX_ENDS
				set(AMPLITUDE_LINE, 'xdata', linspace(t(1), t(end), length(t)));
			end
		end
		
	%-------------------------
	% STOP
	%-------------------------
	
	case ('stop')
		
		%--
		% get axes user data
		%--
	
		fishbowl = get(ax, 'userdata');
				
		%--
		% get warped  amplitude
		%--
		
		amp = get(AMPLITUDE_LINE, 'ydata'); t = get(AMPLITUDE_LINE, 'xdata');
		
		tempgrid = linspace(t(1), t(end), length(fishbowl.amplitude));
			
		%--
		% write updated model
		%--
		
		fishbowl.amplitude = interp1(t, amp, tempgrid, 'spline');
		
		fishbowl.model.y = apply_amplification_factor(get(KNOTS_LINE, 'ydata'), A); 
		
		fishbowl.model.t = apply_amplification_factor(get(KNOTS_LINE, 'xdata'), A);
		
		set(ax, 'userdata', fishbowl);
		
		%--
		% clear edit callbacks
		%--
		
        set(pal, ...
            'WindowButtonMotionFcn', [], ...
            'WindowButtonUpFcn', [] ...
        );
           
end


%----------------------------------------------------------------
% INITIALIZE_DISPLAY
%----------------------------------------------------------------

function flag = initialize_display(ax, component, context)

%--
% early exit
%--

if ~isempty(findobj(ax, 'tag', 'KNOTS_LINE'))
	flag = 0; return;
end

flag = 1;

%--
% setup
%--

pal = get(ax, 'parent');

N = 100;

%--
% draw frequency function
%--

rate = get_sound_rate(context.sound);

event = component.event; 

xlim = [event.time(1) - event.duration, event.time(2) + event.duration];

ylim = [0, (rate / 2000)]; % zero to nyquist

set(ax, ...
	'xlim', xlim, ...
	'ylim', ylim ...
);

%--
% get amplitude axes
%--

handles = get_control(pal, 'amplitude', 'handles');

ax2 = handles.axes;

set(ax2, ...
	'xlim', xlim ...
);

draw_model(ax, ax2, component, N, context);


%----------------------------------------------------------------
% DRAW_MODEL
%----------------------------------------------------------------

function draw_model(ax, ax2, component, N, context)

%---------------------
% SETUP
%---------------------

color = cdss_display_colors;

xlim = get(ax, 'xlim'); 

ylim = get(ax, 'ylim');

%---------------------
% DISPLAY IMAGE
%---------------------

im = lut_dB(component.image);

[rows, cols] = size(im);

% NOTE: this is the quirky grid that the spline model lives on

time = component.event.time;

imx = linspace(time(1), time(2), N);

f = component.event.freq / 1000;

imy = linspace(f(1), f(2), rows);

if ~isempty(im)
	
	imagesc( ...
		'parent', ax, ...
		'xdata', imx, ...
		'ydata', imy, ...
		'cdata', im, ...
		'clipping', 'on', ...
		'hittest', 'off' ...
	);

end

colormap(flipud(gray)); cmap_scale;

set(ax, 'layer', 'top');

hold(ax, 'on');

%---------------------
% DISPLAY MODEL
%---------------------

%--
% reticulate!! spline
%--

[t, yp] = spline_eval(component.model.y, component.model.t, N);

%--
% compute scale factor for derivitive controls
%--

A = get_amplification_factor(component.model, ax);

ym = apply_amplification_factor(component.model.y, 1./A);

tm = apply_amplification_factor(component.model.t, 1./A);

%--
% display intial model lines
%--

% INITIAL MODEL

line(t, yp, ...
    'parent', ax, ...
	'color', color.light_gray, ...
	'linewidth', 1, ...
	'linestyle', '-', ...
	'hittest', 'off' ...
);

t12 = fast_min_max(t);

% INITIAL TIME GRID LINES

INITIAL_GRID = 1;

if INITIAL_GRID
	
	line(t12(1) * ones(1,2), ylim, ...
		'parent', ax, ...
		'color', color.light_gray, ...
		'linestyle', ':', ...
		'tag', 'TIME_GRID_LINES', ...
		'hittest', 'off' ...
	);

	line(t12(2) * ones(1,2), ylim, ...
		'parent', ax, ...
		'color', color.light_gray, ...
		'linestyle', ':', ...
		'tag', 'TIME_GRID_LINES', ...
		'hittest', 'off' ...
	);

	ylim2 = get(ax2, 'ylim');

	line(t12(1) * ones(1,2), ylim2, ...
		'parent', ax2, ...
		'color', color.light_gray, ...
		'linestyle', ':', ...
		'tag', 'TIME_GRID_LINES', ...
		'hittest', 'off' ...
	);

	line(t12(2) * ones(1,2), ylim2, ...
		'parent', ax2, ...
		'color', color.light_gray, ...
		'linestyle', ':', ...
		'tag', 'TIME_GRID_LINES', ...
		'hittest', 'off' ...
	);

	% INITIAL FREQUENCY GRID LINES

	y12 = fast_min_max(yp);

	line(xlim, y12(1) * ones(1,2), ...
		'parent', ax, ...
		'color', color.light_gray, ...
		'linestyle', ':', ...
		'hittest', 'off' ...
	);

	line(xlim, y12(2) * ones(1,2), ...
		'parent', ax, ...
		'color', color.light_gray, ...
		'linestyle', ':', ...
		'hittest', 'off' ...
	);

end

%--
% display editable model lines
%--

line(t, yp, ...
    'tag', 'MODEL_LINE', ...
	'parent', ax, ...
	'linewidth', 2, ...
	'color', color.model ...
);

line(tm(1:2), ym(1:2), ...
	'tag', 'PHANTOM_1', ...
	'parent', ax, ...
	'color', color.model, ...
	'linestyle',':', ...
    'hittest', 'off' ...
);
   
line(tm(end-1:end), ym(end-1:end), ...
    'tag', 'PHANTOM_2', ...
	'parent', ax, ...
	'color', color.model, ...
	'linestyle',':', ...
    'hittest', 'off' ...
);

line(tm, ym, ...
	'tag', 'KNOTS_LINE', ...
	'parent', ax, ...
	'buttondownfcn', {@edit_callback, 'start', component, context, A}, ...
	'color', color.knots, ...
    'linestyle', 'none', ...
    'marker', 'o', ...
	'markersize', 9, ...
    'hittest', 'on' ...
);

a = component.amplitude;

y = interp1(a, linspace(1, length(a), N)); 

line(t, y, ...
	'parent', ax2, ...
	'tag', 'AMPLITUDE_LINE', ...
	'linewidth', 2, ...
	'color', color.model ...
);

ylim = 1.1 * [0, max(y)];

set(ax2, 'ylim', ylim);


%----------------------------------------------------------------
% ENFORCE_RANGE
%----------------------------------------------------------------

function p = enforce_range(p, xlim, ylim)

if p(1) < xlim(1)
	p(1) = xlim(1);
end

if p(1) > xlim(2)
	p(1) = xlim(2);
end

if p(2) < ylim(1)
	p(2) = ylim(1);
end

if p(2) > ylim(2)
	p(2) = ylim(2);
end


%----------------------------------------------------------------
% GET_AMPLIFICATION_FACTOR
%----------------------------------------------------------------

function A = get_amplification_factor(model, ax)

%--
% get required info from input
%--

x = model.t; y = model.y;

xlim = get(ax, 'xlim'); ylim = get(ax, 'ylim');

Ax = get_axes_amplification(x,xlim);

Ay = get_axes_amplification(y, ylim);

A = max(Ax, Ay);


function A = get_axes_amplification(y, ylim)

%--
% compute amplification factor
%--

bot = ylim(1); top = ylim(2);

A = [1, 1];
	
dys = diff(y(1:2)); dye = diff(y(end-1:end));

if y(1) < bot	
	
	A(1) = dys / (y(2) - bot);
	
elseif y(1) > top	
	
	A(1) = dys / (y(2) - top);
	
end

if y(end) < bot
	
	A(2) = dye / (bot - y(end-1));
	
elseif y(end) > top
	
	A(2) = dye / (top - y(end-1));
	
end

A = 1.1 * max(A);
	

%----------------------------------------------------------------
% APPLY_AMPLIFICATION_FACTOR
%----------------------------------------------------------------
	
function y = apply_amplification_factor(y, A)

y(1) = y(2) - A * diff(y(1:2));

y(end) = y(end-1) + A * diff(y(end-1:end));
	
	
%----------------------------------------------------------------
% NEAREST_KNOT
%----------------------------------------------------------------

function [p_knot, ix, p] = nearest_knot(p, ax, knots_line)

if nargin < 3 || isempty(knots_line)
	knots_line = findobj(ax, 'tag', 'KNOTS_LINE');
end

xdata = get(knots_line, 'xdata'); ydata = get(knots_line, 'ydata'); N = length(ydata);

ratio = get(ax, 'dataaspectratio');

dist = ((xdata - p(1)) / ratio(1)).^2 + ((ydata - p(2)) / ratio(2)).^2;

[m, ix] = min(dist);

p_knot = [xdata(ix(1)), ydata(ix(1))];

%--
% add endpoints to p and p_knot
%--

if ix == 2

	ix = [2,1]; 

	d = [xdata(1) - xdata(2), ydata(1) - ydata(2)];

	p = [p; p + d];
	
	p_knot = [p_knot; p_knot + d];

elseif ix == N - 1

	ix = [N - 1, N];

	d = [xdata(end) - xdata(end - 1), ydata(end) - ydata(end - 1)];

	p = [p; p + d];
	
	p_knot = [p_knot; p_knot + d];

end


%----------------------------------------------------------------
% CROSSHAIRS_DATA
%----------------------------------------------------------------

function [time_pos, freq_pos, time_text, freq_text, time_align, freq_align] = crosshairs_data(p, xlim, ylim)

time_text = [num2str(p(1)), ' sec'];

time_pos = [p(1) + 0.025 * diff(xlim), ylim(2) - 0.025 * diff(ylim)]; time_align = 'top';

% if (p(2) > 0.5 * sum(ylim))
% 	time_pos = [p(1), ylim(1)]; time_align = 'bottom';
% else
% 	time_pos = [p(1), ylim(2)]; time_align = 'top';
% end

% FREQ

freq_text = [num2str(p(2)), ' kHz'];

if (p(1) > 0.5 * sum(xlim))
	freq_pos = [xlim(1) + 0.025 * diff(xlim), p(2) + 0.0375 * diff(ylim)]; freq_align = 'left';
else
	freq_pos = [xlim(2) - 0.025 * diff(xlim), p(2) + 0.0375 * diff(ylim)]; freq_align = 'right';
end

