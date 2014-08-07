function pal = tags_table

% TODO: this has two modes, attached to browser, independent

% TODO: we should be able to sort columns, and filter

%--
% create figure and table
%--

pal = fig; 

table = table_layout(pal);

set(pal, ...
	'resizefcn', {@resize_table, table}, ...
	'numbertitle', 'off', ...
	'name', ['Log - '] ...
);

%--
% set menus
%--

table_menu(pal, table);

opt = text_menu; opt.uicontrol = []; text_menu(pal, opt);

set(findobj(pal, 'type', 'uimenu', 'label', 'Fig'), 'position', 3);


%---------------------
% TABLE_LAYOUT
%---------------------

function table = table_layout(pal)

opt = get_palette_settings; opt.fontsize = 9;

table = struct;

%--
% create controls
%--

% TODO: consider log filter

table.label = uicontrol(pal, ...
	'style', 'text', ...
	'string', 'Filter', ...
	'fontsize', opt.fontsize, ...
	'fontunits', 'pixels', ...
	'horizontalalignment', 'left', ...
	'backgroundcolor', get(pal, 'color'), ...
	'tag', 'label' ...
);
	
table.filter = uicontrol(pal, ...
	'style', 'edit', ...
	'units', 'normalized', ...
	'backgroundcolor', 'white', ... 
	'horizontalalignment', 'left', ...
	'fontsize', opt.fontsize, ...
	'fontunits', 'pixels', ...
	'tag', 'filter', ...
	'min', 0, ...
	'max', 1 ...
);

columns  = {'', 'Log', 'Event', 'Tags', 'Start', 'Stop'};

format = {'logical', 'char', 'char', 'char', 'numeric', 'numeric'};

width = {40, 'auto', 'auto', 'auto', 'auto', 'auto'};

editable = [true, false, false, true, true, true];

% TODO: load log data

selected = num2cell(false(1000, 1));

data = num2cell(randn(1000, numel(columns) - 1));

data = [selected, data];

% TODO: set various callbacks

table.table = uitable(pal, ...
	'data', data, ...
	'tag', 'table', ...
	'cellselectioncallback', @select_cell, ...
	'celleditcallback', @edit_cell, ...
	'columnname', columns, ...
	'columnformat', format, ...
	'columnwidth', width, ...
	'columneditable', editable ...
);

resize_table(pal, [], table);

top = uicontextmenu; table.contextmenu = top;

set(table.table, 'uicontextmenu', top);

uimenu(top, 'label', 'CONTEXT-MENU');


%---------------------
% TABLE_MENU
%---------------------

function table_menu(pal, table)

top = uimenu(pal, 'label', 'File'); handle = [];

handle(end + 1) = uimenu(top, 'label', 'Open ...', 'accelerator', 'o');

handle(end + 1) = uimenu(top, 'label', 'Close', 'accelerator', 'w');

handle(end + 1) = uimenu(top, 'label', 'Save', 'accelerator', 's', 'separator', 'on');

handle(end + 1) = uimenu(top, 'label', 'Save As ...');

set(handle, 'callback', {@table_menu_callback, table});


%---------------------
% TABLE_MENU_CALLBACK
%---------------------

function table_menu_callback(obj, eventdata, table)

pal = ancestor(obj, 'figure');

switch get(obj, 'label')
	
	case 'Open ...'
		log = log_load;
		
		data = log_to_table(log);
		
		set(table.table, 'data', data);
		
		% TODO: factor setting title
		
		set(pal, ...
			'numbertitle', 'off', ... 
			'name', ['Log - ', log_name(log)] ...
		);
	
	case 'Close'
		% TODO: ask to save before close
		
		close(pal);
		
	case 'Save'
		% TODO: factor so we can save from multiple places
		
		data = get(table.table, 'data');
		
		log = table_to_log(data, log); % NOTE: not all log information is available in the data table
		
		log_save(log);
		
	case 'Save As ...'
		% TODO: ask for new name, then save
		
end


%---------------------
% SELECT_CELL
%---------------------

function select_cell(obj, eventdata)

db_disp; eventdata


%---------------------
% EDIT_CELL
%---------------------

function edit_cell(obj, eventdata)

db_disp; eventdata


%---------------------
% RESIZE_TABLE
%---------------------

function resize_table(obj, eventdata, handle) %#ok<*INUSL>

%--
% setup
%--

% NOTE: this allows the table to adapt to changes in these settings on resize

opt = get_palette_settings; tile = opt.tilesize;

total = get_size_in(obj, 'px', true);

%--
% position
%--

% left, bottom, width, height

label = 2;

set_size_in(handle.label, 'px', ...
	[0.5 * tile, total.height - 2.25 * tile, label * tile, 1.1 * tile] ...
); 

set_size_in(handle.filter, 'px', ...
	[(label + 0.5) * tile, total.height - 2.25 * tile, total.width - (label + 1.5) * tile, 1.3 * tile] ...
);

set_size_in(handle.table, 'px', ...
	[0, 0, total.width, total.height - 3.25 * tile] ...
); 

%--
% set table properties
%--

set_column_width(handle.table, total);


%---------------------
% SET_COLUMN_WIDTH
%---------------------

function set_column_width(table, total)

%--
% get parent size if needed
%--

if nargin < 2
	total = get_size_in(ancestor(table, 'figure'), true);
end

%--
% update column widths to stretch with figure
%--

columns = numel(get(table, 'columnname'));

% NOTE: the '100' is a fudge factor

check_width = 60;

default = floor((total.width - (check_width + 100)) / (columns - 1));

default(default > 240) = 240; default(default < 80) = 80;

width = num2cell([check_width, default * ones(1, columns - 1)]);

set(table, 'columnwidth', width);


%---------------------
% LOG_TABLE_DATA
%---------------------

function data = log_to_table(log)

% TODO: handle multiple logs

% NOTE: the columns are 'select', 'log' (name), 'event', 'tags', 'start', and 'stop'

count = numel(log.event);

select = num2cell(false(count, 1));

name = repmat({log_name(log)}, count, 1);

tags = cellfun(@str_implode, get_tags(log.event), 'uniformoutput', false)';

event = num2cell([log.event.id])';

time = struct_field(log.event, 'time');

start = num2cell(time(:, 1)); stop = num2cell(time(:, 2));

whos

data = [select, name, event, tags, start, stop];


%---------------------
% LOG_TABLE_DATA
%---------------------

function info = log_table_info

info.columns  = {'', 'Log', 'Event', 'Tags', 'Start', 'Stop'};

info.format = {'logical', 'char', 'char', 'char', 'numeric', 'numeric'};

info.width = {40, 'auto', 'auto', 'auto', 'auto', 'auto'};

info.editable = [true, false, false, true, true, true];




