function ext = time_freq_quartiles

% time_freq_quartiles - time frequency quartiles event measure
% ------------------------------------------------------------
%
% ext = time_freq_quartiles
%
% Output:
% -------
%  ext - event measure extension

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

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 132 $
% $Date: 2004-12-02 15:58:47 -0500 (Thu, 02 Dec 2004) $
%--------------------------------

%------------------------------------
% CREATE EXTENSION
%------------------------------------

% TODO: adapt or implement to support sound measure

% NOTE: some of the code should be reused, the current inheritance mechanism would frown

ext = extension_create;

%--------------------------
% ADMIN
%--------------------------

ext.version = '0.1';

ext.author = 'Harold K. Figueroa';

%--------------------------
% FUNCTION HANDLES
%--------------------------

% %--
% % parameter functions
% %--
% 
% temp = ext.fun.parameter;
% 
% temp.create = @parameter_create;
% 
% temp.describe = @parameter_describe;
% 
% temp.control = @parameter_control;
% 
% ext.fun.parameter = temp;
% 
% %--
% % value functions
% %--
% 
% temp = ext.fun.value; 
% 
% temp.create = @value_create;
% 
% temp.describe = @value_describe;
% 
% temp.display = @value_display;
% 
% temp.display_config = @value_display_config;
% 
% temp.display_config_control = @value_display_config_control;
% 
% ext.fun.value = temp;
% 
% %--
% % compute functions
% %--
% 
% ext.fun.compute = @measure_compute;
% 
% %------------------------------------------------------
% % SET PARAMETERS AND VALUES
% %------------------------------------------------------
% 
% ext.required = [];
% 
% ext.parameter = parameter_create;
% 
% ext.value = value_create;
	

%------------------------------------------------------------------------
% EXTENSION PARAMETER FUNCTIONS
%------------------------------------------------------------------------

%--------------------------------------------------------
% PARAMETER_CREATE
%--------------------------------------------------------

function param = parameter_create

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 132 $
% $Date: 2004-12-02 15:58:47 -0500 (Thu, 02 Dec 2004) $
%--------------------------------

%--
% create parameter structure
%--

% NOTE: use event frequency bounds in computation, default yes

param.freq_bounds = 1;


%--------------------------------------------------------
% PARAMETER_DESCRIBE
%--------------------------------------------------------

function param = parameter_describe

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 132 $
% $Date: 2004-12-02 15:58:47 -0500 (Thu, 02 Dec 2004) $
%--------------------------------

%--
% create parameter structure
%--

param = parameter_create;

%--
% replace values with descriptions
%--

param.freq_bounds = [];


%--------------------------------------------------------
% PARAMETER_CONTROL
%--------------------------------------------------------

function control = parameter_control(param)

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 132 $
% $Date: 2004-12-02 15:58:47 -0500 (Thu, 02 Dec 2004) $
%--------------------------------

%--
% create parameter controls
%--

% TODO: consider computing control from value and description

control = control_create( ...
	'name', 'freq_bounds', ...
	'alias', 'Use Freq Bounds', ...
	'style', 'checkbox' ...
);

%--
% set control values using parameter values
%--

% TODO: develop this framework with 'flatten_struct' in mind

if (nargin < 1)
	param = parameter_create; 
end 

for k = 1:length(control)
	
	% NOTE: transfer parameter field value to control with matching name
	
	if (isfield(param,control(k).name))
		control(k).value = param.(control(k).name);
	end
	
end


%------------------------------------------------------------------------
% EXTENSION VALUE FUNCTIONS
%------------------------------------------------------------------------

%--------------------------------------------------------
%  VALUE_CREATE
%--------------------------------------------------------

function value = value_create

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 132 $
% $Date: 2004-12-02 15:58:47 -0500 (Thu, 02 Dec 2004) $
%--------------------------------

%--
% create value structure
%--

% NOTE: we compute quartiles, inter quartile range, and quartile asymmetry

temp.q1 = []; temp.q2 = []; temp.q3 = []; temp.iqr = []; temp.asy = [];

value.time = temp;

value.freq = temp;


%--------------------------------------------------------
%  VALUE_DESCRIBE
%--------------------------------------------------------

function desc = value_describe

% value_describe - create value description
% -----------------------------------------
%
% desc = value_describe
%
% Output:
% -------
%  desc - structure containing value descriptions

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 132 $
% $Date: 2004-12-02 15:58:47 -0500 (Thu, 02 Dec 2004) $
%--------------------------------

% NOTE: we make value description persistent since it is reasonably complex

persistent VALUE_DESCRIPTION_PERSISTENT;

%--
% create value description
%--

if (isempty(VALUE_DESCRIPTION_PERSISTENT))
	
	%--
	% create value and description structures
	%--

	value = value_create;

	% NOTE: copy structure of value for description we reset leaves
	
	desc = value;
	
	%--
	% replace values with descriptions
	%--

	temp = description_create( ...
		'range', [0,inf], ...
		'units', 'sec' ...
	);

	temp.alias = 'Time Q1';
	desc.time.q1 = temp;

	temp.alias = 'Time Median';
	desc.time.q2 = temp;

	temp.alias = 'Time Q3';
	desc.time.q3 = temp;

	temp.alias = 'Time IQR';
	desc.time.iqr = temp;

	temp.alias = 'Time Asymmetry';
	temp.units = '';
	desc.time.asy = temp;


	temp = description_create( ...
		'range', [0,inf], ...
		'units', 'Hz' ...
	);

	temp.alias = 'Freq Q1';
	desc.freq.q1 = temp;

	temp.alias = 'Freq Median';
	desc.freq.q2 = temp;

	temp.alias = 'Freq Q3';
	desc.freq.q3 = temp;

	temp.alias = 'Freq IQR';
	desc.freq.iqr = temp;

	temp.alias = 'Freq Asymmetry';
	temp.units = '';
	desc.freq.asy = temp;

	%--
	% set description names automatically
	%--

	% NOTE: 'set_canonical_names' sets names to canonical structure names

	desc = set_canonical_names(desc,value);

	%--
	% check descriptions
	%--

	description_check(desc,value);
	
	%--
	% copy description to persistent store
	%--
	
	VALUE_DESCRIPTION_PERSISTENT = desc;
	
%--
% copy value description
%--

else
	
	desc = VALUE_DESCRIPTION_PERSISTENT;
	
end


%--------------------------------------------------------
% MEASURE_COMPUTE
%--------------------------------------------------------

% TODO: in the meaasure interface wrap this so we can measure performance

function value = measure_compute(sound,event,param)

% measure_compute - compute measurement
% -------------------------------------
%
% value = measurement_compute(sound,event,param)
%
% Input:
% ------
%  sound - sound that contains event
%  event - event to measure
%  param - measurement parameters
%
% Output:
% -------
%  value - measure value

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 132 $
% $Date: 2004-12-02 15:58:47 -0500 (Thu, 02 Dec 2004) $
%--------------------------------

%--
% create value structure
%--

value = value_create;

%--
% get and demean event data
%--

% TODO: consider getting more samples to compute the spectrogram properly

% TODO: check the computation of time within the spectrogram function

X = sound_read(sound,'time',event.time(1),event.duration,event.channel);

X = X - mean(X);

%--
% compute time quartiles
%--

t = event.time(1); r = sound.samplerate;

c = cumsum(X.^2); c = c / c(end);

q = fast_quartiles_(c);

value.time_q1 = t + q(1)/r;

value.time_q2 = t + q(2)/r;

value.time_q3 = t + q(3)/r;

value.time_iqr = value.time_q3 - value.time_q1;

value.time_asy = (value.time_q2 - value.time_q1) / value.time_iqr;

%--
% compute frequency quartiles
%--

[B,f,t] = fast_specgram(X,r,'power',param);

n = size(B,2); B = sum(B,2) / n;

c = cumsum(B); c = c / c(end);

q = fast_quartiles_(c);

value.freq_q1 = f(q(1));

value.freq_q2 = f(q(2));

value.freq_q3 = f(q(3));

value.freq_iqr = value.freq_q3 - value.freq_q1;

value.freq_asy = (value.freq_q2 - value.freq_q1) / value.freq_iqr;



%--------------------------------------------------------
%  MEASURE_DISPLAY
%--------------------------------------------------------

function g = measure_display(h,m,event,ixa,description,data,mode)

% measure_display - graphical displays of measure data
% ----------------------------------------------------
%
% g = measurement_display(h,m,event,ixa,description,data)
%
% Input:
% ------
%  h - handle to figure
%  m - log index
%  event - annotated event
%  ixa - measurement index
%  description - measurement description
%  data - figure userdata context
%
% Output:
% -------
%  g - handles to created graphic objects

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 132 $
% $Date: 2004-12-02 15:58:47 -0500 (Thu, 02 Dec 2004) $
%--------------------------------

%--
% create list of available display modes
%--

% % PERSISTENT MODES;
% 
% if (isempty(MODES))
% 	MODES = { ...
% 		'Plot 1', ...
% 		'Plot 2', ...
% 		'Plot 3' ...
% 	};
% end
% 
% %--
% % output modes for no input arguments
% %--
% 
% if (~nargin)
% 	g = MODES;
% 	return;
% end
% 
% %--
% % check mode
% %--
% 
% if (nargin < 1)
% 	
% 	mode = 'Inline';
% 	
% else
% 	
% 	ix = find(strcmp(mode,{MODES{:},'Inline'}));
% 	
% 	if (isempty(ix))
% 		
% 		disp(' ');
% 		warning(['Unrecognized display mode ''' mode '''.']);
% 		
% 		g = []; 
% 		return;	
% 		
% 	end
% 	
% end

%--
% create display mode
%--

switch (mode)
	
	%--
	% inline display
	%--
	
	case ('Inline')
		
		%--
		% set linestyle and color
		%--
		
		if (strcmp(data.browser.renderer,'OpenGL'))
			lw1 = 1; 
			lw2 = 1.5;
		else
			lw1 = 0.5 + eps;
			lw2 = 2;
		end
		
		rgb1 = [1 1 0];
		rgb2 = [1 1 0];
		
		%--
		% get value
		%--
		
		value = event.measurement(ixa).value;
		
		%--
		% get frequency scaling
		%--
		
		if (strcmp(data.browser.grid.freq.labels,'kHz'))
			kHz_flag = 1;
		else
			kHz_flag = 0;
		end
		
		%--
		% display time quartiles and fences (reduced box plot)
		%--
		
		y = value.freq_q2;
		y = y * ones(1,3);
		
		if (kHz_flag)
			y = y / 1000;
		end
		
		off = 1.5 * value.time_iqr;
		x = [value.time_q1 - off, value.time_q3 + off];
		
		g(2) = line( ...
			'xdata',x, ...
			'ydata',y(1:2), ...
			'linestyle',':', ...
			'marker','+', ...
			'color',rgb2, ...
			'linewidth',lw1 ...
		);
		
		x = [value.time_q1, value.time_q2, value.time_q3];
		
		g(1) = line( ...
			'xdata',x, ...
			'ydata',y, ...
			'linestyle','-', ...
			'color',rgb1, ...
			'linewidth',lw2 ...
		);	
		
		%--
		% display frequency quartiles and fences (reduced box plot)
		%--
		
		x = value.time_q2;
		x = x * ones(1,3);
		
		if (kHz_flag)
			y = y / 1000;
		end
		
		off = 1.5 * value.freq_iqr;
		y = [value.freq_q1 - off, value.freq_q3 + off];
		if (kHz_flag)
			y = y / 1000;
		end
		
		g(4) = line( ...
			'xdata',x(1:2), ...
			'ydata',y, ...
			'linestyle',':', ...
			'marker','+', ...
			'color',rgb2, ...
			'linewidth',lw1 ...
		);	
		
		y = [value.freq_q1, value.freq_q2, value.freq_q3];
		if (kHz_flag)
			y = y / 1000;
		end
		
		g(3) = line( ...
			'xdata',x, ...
			'ydata',y, ...
			'linestyle','-', ...
			'color',rgb1, ...
			'linewidth',lw2 ...
		);	
		
		%--
		% make the display non-interfering with the interface
		%--
		
		set(g,'hittest','off');
		
	%--
	% plot of type 1
	%--
	
	case ('Plot 1')
		
		disp('plot1');
		g = [];
	
	%--
	% plot of type 2
	%--
	
	case ('Plot 2')
		
		disp('plot2');
		g = [];
		
	%--
	% unrecognized display mode
	%--
	
	otherwise
		
		disp(' ');
		warning(['Unrecognized display mode ''' mode '''.']);
		
		g = []; 
		
end
