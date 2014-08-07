function set_widget_extension(widget, ext)

data = get(widget, 'userdata');

data.opt.ext = ext;

set(widget, 'userdata', data);
