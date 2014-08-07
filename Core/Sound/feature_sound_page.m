function page = feature_sound_page(page, context)

% feature_sound_page - "feature" a sound page using context
% ---------------------------------------------------------
%
% page = feature_sound_page(page, context)
%
% Input:
% ------
%  page - page to "feature"
%  context - context
%
% Output:
% -------
%  page - featured page

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
% check if we need to compute features
%--

if isempty(context) || isempty(context.active.sound_feature)
	page.feature = []; return;
end

%--
% feature page
%--

feature = context.active.sound_feature;

for k = 1:length(feature)

	ext = feature(k);

	%--
	% compute
	%--

	page.feature(k).name = ext.name; page.feature(k).value = [];

	try
		[page.feature(k).value, context(k)] = ext.fun.compute(page, ext.parameter, context(k));
	catch
		extension_warning(feature(k), 'Compute failed.', lasterror);
	end

end
