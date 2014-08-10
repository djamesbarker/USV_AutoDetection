function [out, info] = render_model_callback(obj, eventdata, store, context)

% render_model_callback - callback to render model to file
% --------------------------------------------------------
%
% [out, info] = render_model_callback(obj, eventdata, store, context)
%
% Input:
% ------
%  store - handle to object storing model
%  context - extension context
%
% Output:
% -------
%  out - full output filename
%  info - output file info

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

%--
% get model data, this contains events and components
%--

data = get(store, 'userdata');

%--
% create and play model signal
%--

[signal, rate] = get_model_signal(data, context);

%--
% create prompt user for filenames
%--

[out1, out2] = uiputfile({'*.wav',  'WAV-files (*.wav)'}, 'Render Model Signal To ...');

if isequal(out1, 0)
	return;
end

out = [out2, out1];

%--
% create file
%--

wavwrite(signal, rate, 16, out);

if (nargout > 1)
	info = dir(out);
end
