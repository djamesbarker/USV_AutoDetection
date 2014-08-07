function pal = test_waveform(sound,page)

%---------------------------------
% CREATE CONTROLS
%---------------------------------

% Copyright (C) 2002-2012 Cornell University

%
% This file is part of XBAT.
% 
% XBAT is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 2 of the License, or
% (at your option) any later version.
% 
% XBAT is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with XBAT; if not, write to the Free Software
% Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA

control = control_create( ...
	'style','separator', ...
	'type','header', ...
	'space',2, ...
	'string','Waveform' ...
);

control(end + 1) = control_create( ...
	'name','display', ...
	'label',0, ...
	'style','axes', ...
	'space',2, ...
	'lines',6 ...
);

control(end + 1) = control_create( ...
	'name','time', ...
	'style','slider', ...
	'align','right', ...
	'active',1, ...
	'onload',1, ...
	'min',0, ...
	'max',sound.duration - page ...
);

control(end + 1) = control_create( ...
	'name','page', ...
	'style','slider', ...
	'width',2/3, ...
	'space',1.5, ...
	'value',page, ...
	'slider_inc',[1,2], ...
	'min',0.1, ...
	'max',sound.duration - page ...
);

%---------------------------------
% CREATE PALETTE
%---------------------------------

% TODO: implement cell callbacks in 'control_group' so we can use it here

opt = dialog_group;

opt.top = 0; opt.width = 24; opt.left = 2; opt.right = 2;

out = dialog_group(sound_name(sound),control,opt,{@palette_callback,sound});


%--------------------------------
% PALETTE_CALLBACK
%--------------------------------

function palette_callback(obj,eventdata,sound)

%--
% get callback context
%--

call = get_callback_context(obj,'pack');

%--
% perform control updates
%--

switch (call.control.name)
	
	case ('display')
		
		% TODO: use display to zoom and/or play sound
		
	case ('time'), slider_sync(obj,call.control.handles);
	
	case ('page'), slider_sync(obj,call.control.handles);
		
end

%--
% get relevant control values and sound data
%--

[ignore,time] = control_update([],call.pal.handle,'time');
		
[ignore,page] = control_update([],call.pal.handle,'page');

X = sound_read(sound,'time',time,page,1);

%--
% update display
%--

wave = findobj(call.pal.handle,'tag','WAVE_LINE');

if (~isempty(wave))
	set(wave,'ydata',X);
else
	wave = plot(X); 
end

set(get(wave,'parent'), ...
	'xlim',[1,length(X)], ...
	'xtick',[], ...
	'xticklabel',[], ...
	'ylim',[-1,1], ...
	'ytick',[], ...
	'yticklabel',[] ...
);
