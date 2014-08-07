function [Y, info] = apply_signal_filter(X, ext, context)

% apply_signal_filter - apply signal filter
% -----------------------------------------
% 
% [Y, info] = apply_signal_filter(X, ext, context)
%
% Input:
% ------
%  X - signal 
%  ext - filter extension
%  context - context
%
% Output:
% -------
%  Y - filtered signal
%  info - coarse profile information

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

%--------------------
% HANDLE INPUT
%--------------------

%--
% create minimal context, ensure we have debug
%--

if (nargin < 3) || isempty(context)
	
	context = struct;
	
	context.debug = 0;
	
	if isfield(ext.control, 'debug')
		context.debug = ext.control.debug;
	end

else
	
	if ~isfield(context, 'debug') && isfield(ext.control, 'debug')
		context.debug = ext.control.debug;
	end

end

%--------------------
% SETUP
%--------------------
	
%--
% get fade from opacity if available
%--

if ~isfield(ext.control, 'opacity')
	fade = 0;
else
	fade = 1 - ext.control.opacity;
end

% NOTE: full fade means no need to compute

if fade == 1
	Y = X; return;
end

%--
% get input form and possibly start time
%--

form = get_form(X);

if nargout > 1
	start = clock; 
end

%--
% handle float to double conversion if needed
%--

% TODO: consider extension flag to indicate native float support

if isfloat(X)
	X = double(X);
end

%--------------------
% COMPUTE
%--------------------

% NOTE: most simple linear filters are multi-channel filters

if ext.multichannel
	
% 	db_disp('multi-channel'); context
	
	%--
	% compile parameters
	%--
	
	if ~isempty(ext.fun.parameter.compile)
		
		try
			ext.parameter = ext.fun.parameter.compile(ext.parameter, context);
		catch
			extension_warning(ext, 'Multi-Channel compilation failed.', lasterror);
		end
		
	end
	
	%--
	% filter signal
	%--
	
	try
		Y = ext.fun.compute(X, ext.parameter, context);
	catch
		Y = X; extension_warning(ext, 'Multi-Channel compute failed.', lasterror);
	end
	
else
	
% 	db_disp('single-channel'); context
	
	%--
	% get channels info from context
	%--
	
	% NOTE: this is the critical part of the context we update as we loop
	
	if isfield(context, 'page')
		channels = context.page.channels;
	else
		channels = [];
	end
	
	%--
	% loop over channels
	%--
	
	for k = 1:size(X, 2)

		%--
		% update context to consider channels
		%--
		
		if ~isempty(channels)
			context.page.channels = channels(k);
		end
		
		%--
		% copy page samples into context
		%--
		
		context.page.samples = X(:, k);
		
		%--
		% compile parameters
		%--
		
		if ~isempty(ext.fun.parameter.compile)
			
			try
				ext.parameter = ext.fun.parameter.compile(ext.parameter, context);
			catch
				extension_warning(ext, 'Channel compilation failed.', lasterror);
			end

		end

		%--
		% filter signal
		%--
		
		try
			Y(:,k) = ext.fun.compute(X(:,k), ext.parameter, context);
		catch
			Y(:,k) = X(:,k); extension_warning(ext, 'Channel compute failed.', lasterror);
		end

	end

end
	
%--
% check output form
%--

try
	Y = set_form(Y, form);
catch
	Y = X; extension_warning(ext, 'Incompatible output form.', lasterror);
end

%--
% fade
%--

% TODO: consider context flag to indicate native fade support

if fade > 0
	Y = fade * X + (1 - fade) * Y;
end

%--------------------
% PROFILE
%--------------------

%--
% get coarse profile information if needed
%--

% TODO: put this into a function

if (nargout > 1)
	
	info.ext = [ext.subtype, '::', ext.name];
	
	info.time = etime(clock, start);

	info.form = form;

	info.rate = numel(X) / (info.time * 10^6); 

end


