function selection_patch_callback(obj, eventdata, sel, opt)

% selection_patch_callback - patch callback router
% ------------------------------------------------
%
% selection_patch_callback(obj, eventdata, sel, opt)
%
% Input:
% ------
%  obj, eventdata - matlab callback input
%  sel - selection
%  opt - selection options

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
% get selection options from axes if needed
%--

if isempty(opt)
	opt = get_axes_selection_options(get(obj, 'parent'));
end

%--
% execute custom patch callback
%--

if double_click(obj)

	if ~isempty(opt.callback.patch.double_click)
		eval_callback(opt.callback.patch.double_click, obj, eventdata, sel, opt);
	end

else

	if ~isempty(opt.callback.patch.click)
		eval_callback(opt.callback.patch.click, obj, eventdata, sel, opt);
	end

end
