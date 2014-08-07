function pos = get_computed_position(control,k,opt,X,dX,dY,tix,hix,ignore_panes)

% get_computed_position - compute control element positions
% ---------------------------------------------------------
%
% pos = get_computed_position(control,k,opt,data)
%
% Input:
% ------
%  control - control
%
% Output:
% -------
%  pos - position structure

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
% $Revision: 3398 $
% $Date: 2006-02-04 13:13:16 -0500 (Sat, 04 Feb 2006) $
%--------------------------------

% TODO: all positions should be computed at once, to avoid N squared loop

%-----------------------------------------------------------
% remove controls from other tabs or panes before us
%-----------------------------------------------------------

%--
% check whether there are tabs before us
%--

ix = find(tix < k);

if (~isempty(ix))

	%--
	% get tabs before us along with their panes to ignore
	%--

	tix = tix(ix);

	ignore_panes = ignore_panes(ix);

	%--
	% handle the case when the control is part of a tab group
	%--

	if (~isempty(control(k).tab) && ~strcmp(control(k).style,'tabs'))

		%--
		% remove the pane that we belong to from the panes to ignore
		%--

		ix = max(ix);

		panes = ignore_panes{ix};

		tmp = find(strcmp(panes,control(k).tab));

		if (~isempty(tmp))

			if (ischar(panes))
				panes = cell(0); % ours was the pane to ignore
			else
				panes(tmp) = [];
			end

		end

		%--
		% remove panes that come after us
		%--

		tmp = find(strcmp(control(tix(ix)).tab,control(k).tab)); % position of our control's tab

		if (ischar(panes))

			tmp2 = find(strcmp(control(tix(ix)).tab,panes));

			if (tmp2 > tmp)
				panes = cell(0);
			end

		else

			for j = length(panes):-1:1

				tmp2 = find(strcmp(control(tix(ix)).tab,panes{j}));

				if (tmp2 > tmp)
					panes(j) = [];
				end

			end

		end

		%--
		% add panes that come before us
		%--

		tmp = find(strcmp(control(tix(ix)).tab,control(k).tab)); % position of our control's tab

		if (tmp > 1)

			if (ischar(panes))
				tmp = control(tix(ix)).tab(1:(tmp - 1));
				panes = {panes, tmp{:}};
			else
				tmp = control(tix(ix)).tab(1:(tmp - 1));
				panes = {panes{:}, tmp{:}};
			end

		end

		if (~ischar(panes))
			panes = unique(panes);
		end

		ignore_panes{ix} = panes;

		%--
		% remove controls
		%--

		% NOTE: we scan arrays in reverse order since we are removing controls

		for j = length(tix):-1:1

			if (hix(j) ~= -1)
				last = hix(j) - 1;
			else
				last = length(control);
			end

			%--
			% loop over all controls that belong to the tab group
			%--

			for i = last:-1:(tix(j) + 1)

				% remove control if it is a child of an ignored pane

				if (~isempty(find(strcmp(ignore_panes{j},control(i).tab),1)))

					control(i) = [];
					k = k - 1;

				end

			end

		end

	else

		%--
		% remove controls
		%--

		% NOTE: we scan arrays in reverse order since we are removing controls

		for j = length(tix):-1:1

			if (hix(j) ~= -1)
				last = hix(j) - 1;
			else
				last = length(control);
			end

			%--
			% loop over all controls that belong to the tab group
			%--

			for i = last:-1:(tix(j) + 1)

				% remove control if it is a child of an ignored pane

				if (~isempty(find(strcmp(ignore_panes{j},control(i).tab),1)))

					control(i) = [];
					k = k - 1;

				end

			end

		end

	end

end

%--
% compute space taken up by previous controls and margin
%--

part = opt.top;

for j = 1:(k - 1)
	part = part + get_height(control(j));
end

%--
% set compact layout constants
%--

% TODO: the layout of compact controls still requires more work

% NOTE: these constants should sum to one

COMPACT_OFFSET = 2/10;

LABEL_LENGTH = 3.75/10; % 3.75/10;

SLIDER_LENGTH = 5/10; % used to be 5.25/10;

SLIDER_EDIT_LENGTH = 3/10; % used to be 2.75/10;

% NOTE: along with compact offset sums to one

POPUP_LENGTH = 8.5/10;

%-------------------------------------------------------------
% compute position of main control element
%-------------------------------------------------------------

style = control(k).style;

switch (control(k).layout)

	%--
	% normal layout
	%--

	case ('normal')
		
		pos.(style) = [ ...
			(opt.left * dX), ...
			1 - (part + control(k).lines + control(k).label) * dY, ...
			control(k).width * X, ...
			control(k).lines * dY ...
		];

	%--
	% compact layout
	%--

	% only implemented for sliders, edit, and popupmenu controls

	case ('compact')

		%--
		% apply compact layout depending on style
		%--

		switch (style)

			%--
			% compact slider
			%--

			case ('slider')

				pos.(style) = [ ...
					(opt.left + (COMPACT_OFFSET * opt.width)) * dX, ...
					1 - (part + control(k).lines) * dY, ...
					SLIDER_LENGTH * control(k).width * X, ...
					control(k).lines * dY ...
				];

			%--
			% compact edit box and popup menu
			%--

			case ({'edit','popup'})

				if (strcmp(control(k).type,'slider_length'))
					tmp = SLIDER_LENGTH;
				else
					tmp = POPUP_LENGTH;
				end

				pos.(style) = [ ...
					(opt.left + (COMPACT_OFFSET * opt.width)) * dX, ...
					1 - (part + control(k).lines) * dY, ...
					tmp * control(k).width * X, ...
					control(k).lines * dY ...
				];

			%--
			% other controls (same as 'normal' layout)
			%--

			otherwise

				pos.(style) = [ ...
					(opt.left * dX), ...
					1 - (part + control(k).lines + control(k).label) * dY, ...
					control(k).width * X, ...
					control(k).lines * dY ...
				];

		end

end

%--
% compute alignment induced offset and udpate position if needed
%--

% NOTE: the alignment update probably needs to be aware of the layout

dh = align_offset(control(k),X);

if (dh ~= 0)
	pos.(style)(1) = pos.(style)(1) + dh;
end

%-------------------------------------------------------------
% compute position of label if needed
%-------------------------------------------------------------

% NOTE: the string control property controls size of the label and
% possibly of an accompanying object in the same line as the label

if (isempty(control(k).string))

	% there is a problem with the use of hop and length in this function

	if (strcmp(control(k).style,'waitbar'))
		len = 0;
	else
		len = 0.45;
	end

	hop = 1 - len;
	
else

	if (isnumeric(control(k).string) && (control(k).string < 1)) % check that this field is in fact numeric

		len = control(k).string;
		hop = 1 - control(k).string;

	else

		len = 1/3; % this is the default length of an edit box that accompanies the slider
		hop = 1 - len;

	end

end

if (control(k).label)

	switch (control(k).layout)

		case ('normal')

			pos.label = [ ...
				(opt.left * dX), ...
				1 - (part + 1) * dY ... % note that +1 is the label line
				hop * control(k).width * X, ...
				dY ...
			];

		case ('compact')

			switch (style)

				%--
				% compact slider, edit box, and pop up menu
				%--

				case ({'slider','edit','popup'})

					% there are some fragile placement commands here

					pos.label = [ ...
						max(0,(opt.left - (COMPACT_OFFSET * opt.width))* dX), ...
						1 - (part + 1 + 0.6) * dY ...
						min(0.9 * pos.(style)(1),(LABEL_LENGTH) * control(k).width * X), ...
						1.6 * dY ...
					];

				%--
				% other controls (same as 'normal' layout)
				%--

				otherwise

					pos.label = [ ...
						(opt.left * dX), ...
						1 - (part + 1) * dY ... % note that +1 is the label line
						hop * control(k).width * X, ...
						dY ...
					];

			end

	end

end

%-------------------------------------------------------------
% compute position of additional elements (depending on control)
%-------------------------------------------------------------

if (strcmp(style,'slider'))

	%--
	% compute edit position
	%--

	switch (control(k).layout)

		%--
		% normal slider
		%--

		case ('normal')

			pos.edit = [ ...
				(opt.left * dX) + hop * control(k).width * X, ...
				1 - (part + 1) * dY, ... % note that +1 is the label line
				len * control(k).width * X, ...
				dY ...
			];

			%--
			% compact slider
			%--

		case ('compact')

			pos.edit = [ ...
				(opt.left + ((COMPACT_OFFSET + SLIDER_LENGTH) * opt.width)) * dX, ...
				1 - (part + control(k).lines) * dY, ...
				SLIDER_EDIT_LENGTH * control(k).width * X, ...
				control(k).lines * dY ...
			];

	end

elseif (strcmp(style,'listbox'))

	%--
	% listbox has confirmation buttons
	%--

	if (control(k).confirm == 1)

		%--
		% update position of listbox and compute position of buttons
		%--

		% note that at the moment this depends on the assumptions being made
		% regarding button size and number of buttons. 2 is the space we are
		% allocating for the buttons

		pos.(style)(2) = pos.(style)(2) + (2 * dY);
		pos.(style)(4) = pos.(style)(4) - (2 * dY);

		%--
		% compute confirm button positions (at the time 'Apply' and 'Cancel'
		%--

		tmp = control(k).width / 2;

		pos.buttons{1} = [ ...
			(opt.left * dX), ...
			1 - (part + control(k).lines + control(k).label) * dY, ...
			tmp * X, ...
			1.75 * dY ...
		];

		pos.buttons{2} = [ ...
			(opt.left * dX) + (tmp * X), ...
			1 - (part + control(k).lines + control(k).label) * dY, ...
			tmp * X, ...
			1.75 * dY ...
		];

	end

elseif (strcmp(style,'separator'))

	% this should perhaps be treated as a special case before

	%--
	% compute simple and hidden header separator position
	%--

	if (~strcmp(control(k).type,'header'))

		pos.separator = [ ...
			0, ...
			1 - (part + control(k).lines) * dY, ...
			1, ...
			0.05 * dY ... % make this one pixel regardless of dY
		];

	%--
	% compute header position
	%--

	else

		pos.separator = [ ...
			0, ...
			1 - (part + control(k).lines) * dY, ...
			1, ...
			1.25 * dY ... % make this fit the title string, there seems to be some offset
		];

	end

elseif (strcmp(style,'buttongroup'))

	if (~ischar(control(k).name))

		%--
		% compute button tiling variables
		%--

		[m,n] = size(control(k).name);

		tmp = pos.buttongroup;

		dx = tmp(3) / n;
		dy = tmp(4) / m;

		%--
		% compute individual button positions
		%--

		% consider alignment

		dh = align_offset(control(k),X);

		pos.buttongroup = cell(m,n);

		for i = 1:m
		for j = 1:n
			
			pos.buttongroup{i,j} = [ ...
				tmp(1) + (j - 1)*dx + dh, ...
				tmp(2) + (m - i)*dy, ...
				dx, ...
				dy ...
			];
		
		end
		end

	end

elseif (strcmp(style,'popup') && control(k).confirm)

	% the size of the confirm axes should be settable. this should be done
	% in some way using the confirm field. for the moment it is hard coded
	% into a shape that works for the color display in the log color and
	% perhaps the grid color

	% 	len = 0.25; % this is a default value for the size of the title
	% 	hop = 1 - len;

	%--
	% compute confirm axes position
	%--

	pos.axes = [ ...
		(opt.left * dX) + (control(k).width * X - (2.15 * dX)), ...
		1 - (part + 1 - 0.15) * dY, ...
		2 * dX, ...
		dY ...
	];

elseif (strcmp(style,'waitbar') && control(k).confirm)

	%--
	% compute remaining time position
	%--

	hop = 0.25; len = 1 - hop;

	pos.time = [ ...
		(opt.left * dX) + hop * control(k).width * X, ...
		1 - (part + control(k).label + control(k).lines + 1.5) * dY, ... 
		len * control(k).width * X, ...
		dY ...
	];

end


%-------------------------------------------------------------
% ALIGN_OFFSET
%-------------------------------------------------------------

function dh = align_offset(control,X)

% align_offset - compute alignment offset for control
% ---------------------------------------------------
%
% dh = align_offset(control,X)
%
% Input:
% ------
%  control - control to align
%  X - real palette width
%
% Output:
% -------
%  dh - horizontal offset due to alignment

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 3398 $
% $Date: 2006-02-04 13:13:16 -0500 (Sat, 04 Feb 2006) $
%--------------------------------

%--
% return if control is full width or left aligned
%--

if ((control.width == 1) || strcmp(control.align,'left'))
	dh = 0; return;
end

%--
% compute offset based on alignment type
%--

% NOTE: there is a discrepancy in how this works for button groups

switch (control.align)

	%--
	% center alignment (half shift)
	%--

	case ('center')

		if (~strcmp(control.style,'buttongroup'))
			dh = (X * (1 - control.width)) / 2;
		else
			dh = (X * (1 - control.width)) / 4;
		end

	%--
	% right align (full shift)
	%--

	case ('right')

		if (~strcmp(control.style,'buttongroup'))
			dh = (X * (1 - control.width));
		else
			dh = (X * (1 - control.width)) / 2;
		end

	%--
	% error
	%--

	otherwise

		error(['Unrecognized alignment option ''', control.align, '''.']);

end
