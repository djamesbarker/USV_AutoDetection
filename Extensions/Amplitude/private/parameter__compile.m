function [parameter, context] = parameter__compile(parameter, context)

% AMPLITUDE - parameter__compile

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
% consider adapt request
%--

% NOTE: we check whether adaptation is requested and possible in context

if ~parameter.auto || ~isfield(context, 'page')
	return;
end

%--
% adapt block
%--

rate = get_sound_rate(context.sound); 

block = get_block_range(rate);

parameter.block = clip_to_range(context.page.duration / 1000, block);

%--
% update block control 
%--

pal = get_extension_palette(context.ext, context.par);

if isempty(pal)
	return; 
end

set_control(pal, 'block', 'value', parameter.block);
