function result = parameter__control__callback(callback, context)

% BANDPASS - parameter__control__callback

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

%-----------------------------
% SETUP
%-----------------------------

%--
% unpack callback context 
%--

obj = callback.obj; control = callback.control; 

pal = callback.pal.handle; par = callback.par.handle;

%--
% get rate and nyquist from context
%--

rate = get_sound_rate(context.sound); nyq = 0.5 * rate;

%--
% get some ubiquitously needed control values
%--

min_band = context.ext.parameter.min_band;

if has_control(pal, 'min_freq')
	min_freq = get_control(pal, 'min_freq', 'value');
else
	min_freq = context.ext.parameter.min_freq;
end

if has_control(pal, 'max_freq')
	max_freq = get_control(pal, 'max_freq', 'value');
else
	max_freq = context.ext.parameter.max_freq;
end

trans = get_control(pal, 'transition', 'value');

%-----------------------------
% CONTROL CALLBACKS
%-----------------------------

switch control.name
	
	%--
	% configure using selection
	%--
	
	case 'sel_config'
		
		[selection, count] = get_browser_selection(par);
		
		if ~count
			return;
		end
		
		freq = selection.event.freq;
		
		% TODO: check that the values are reasonable, make them reasonable
		
		set_control(pal, 'min_freq', 'value', freq(1));
		
		set_control(pal, 'max_freq', 'value', freq(2));
		
	%--
	% min and max freq
	%--
	
	case 'min_freq'	
			
		%--
		% handle constraints
		%--
		
		min_freq = min(min_freq, max_freq - min_band);
		
		set_control(pal, 'min_freq', 'value', min_freq);
		
		max_trans = min(nyq - max_freq, min_freq);
		
		if max_trans < min_band
			max_trans = max(nyq - max_freq, min_freq);
		end
		
		max_trans = max_trans - 1;

		%--
		% update related
		%--
		
		set_control(pal, 'transition', 'max', max_trans);
	
	case 'max_freq'
		
		%--
		% handle constraints
		%--
		
		max_freq = max(max_freq, min_freq + min_band);
		
		set_control(pal, 'max_freq', 'value', max_freq);
		
		max_trans = min(nyq - max_freq, min_freq);
		
		if max_trans < min_band
			max_trans = max(nyq - max_freq, min_freq);
		end
		
		max_trans = max_trans - 1;
		
		%--
		% update related
		%--
		
		set_control(pal, 'transition', 'max', max_trans);
	
	%--
	% transition
	%--

	case 'transition'
		
		if min_freq ~= 0
			min_val = trans + 1;
			
			if min_freq < min_val
				set_control(pal, 'min_freq', 'value', min_val);
			end
			
			set_control(pal, 'min_freq', 'min', min_val);
		end
		
		if max_freq ~= nyq
			max_val = nyq - trans - 1;
			
			if max_freq > max_val
				set_control(pal, 'max_freq', 'value', max_val);
			end
			
			set_control(pal, 'max_freq', 'max', max_val);
		end
		
	%--
	% estimate
	%--			
	
	case 'estimate'
		
		state = get(obj, 'value');
		
		set_control(pal, 'length', 'enable', ~state);
		
		set_control(pal, 'stop_ripple', 'enable', state);
		
		set_control(pal, 'pass_ripple', 'enable', state);	
		
	%--
	% distortion
	%--
		
	case {'stop_ripple', 'pass_ripple'}
		
% 		ext = get_browser_extension('signal_filter', par.handle, context.ext.name);
% 		
% 		set_control(pal, 'length', 'value', ext.parameter.length);
				
end

%--
% get extension to compile and update length
%--

if ~strcmp(callback.control.name, 'estimate')
	
	ext = get_extension('signal_filter', context.ext.name, pal);

	set_control(pal, 'length', 'value', ext.parameter.length);
	
end
		
%-----------------------------
% UPDATE DISPLAY
%-----------------------------

%--
% execute parent callback to perform main part of display
%--

fun = parent_fun; result = fun(callback, context);


