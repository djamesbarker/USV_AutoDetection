function handles = explain__display(par, data, parameter, context)

% DATA TEMPLATE - explain__display

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

if isempty(data)
	handles = []; return;
end

% NOTE: this is some dummy parameter code, eventual code should include these

clear parameter;

parameter.correlation = 0;

parameter.smooth = 1;

parameter.stem = 1;

parameter.balloon = 1;

parameter.label = 1;


%-----------------------------------
% SETUP
%-----------------------------------

%--
% unpack parts of context
%--

ext = context.ext;

page = context.page;

%--
% create clip colors
%--

colors = plot_colors(length(data.clip));

%-----------------------------------
% DISPLAY
%-----------------------------------

handles = [];

for k = 1:length(page.channels)
	
	%--
	% find container axes
	%--
	
	ax = findobj(par,'type','axes','tag',int2str(page.channels(k)));
	
	% NOTE: continue if we can't find container axes
	
	if (isempty(ax))
		continue;
	end

	%--
	% loop over clips
	%--

	for j = 1:length(data.correlation)
		
		%----------------------------
		% FEATURE
		%----------------------------
		
		%--
		% compute time grid
		%--

		% NOTE: this is precise
		
		time = linspace(data.time(1), data.time(2), length(data.correlation{j}) + 1);
		
		duration = diff(data.time);
		
		time = time(1:(end - 1));
		
		%--
		% display actual correlation
		%--

		if parameter.correlation
			
			handles(end + 1) = line( ...
				'parent', ax, ...
				'color', colors(j,:) + 0.6 * (1 - colors(j,:)) , ...
				'linestyle', ':', ...
				'visible', 'on', ...
				'xdata', time, ...
				'ydata', data.correlation{j} ...
			);
	
		end
	
		%--
		% display smooth correlation
		%--

		if parameter.smooth
		
			handles(end + 1) = line( ...
				'parent', ax, ...
				'color', colors(j,:), ...
				'visible', 'on', ...
				'xdata', time, ...
				'ydata', data.smooth{j} ...
			);

		end
		
		%----------------------------
		% DECISION
		%----------------------------
		
		%--
		% setup
		%--
		
		% NOTE: clip contains tags
		
		clip = data.clip{j};
		
		% NOTE: get peak information from data
		
		actual_ix = data.actual_peaks{j};
		
		actual_t = time(actual_ix); 
		
		actual_val = data.correlation{j}(actual_ix);
		
		smooth_ix = data.smooth_peaks{j}; 
		
		smooth_t = time(smooth_ix);
		
		smooth_val = data.smooth{j}(smooth_ix);
		
		%--
		% display peak locations
		%--
		
		if parameter.balloon
			
			handles(end + 1) = line( ...
				'parent',ax, ...
				'color',[0 0 0], ...
				'linestyle','none', ...
				'marker','o', ...
				'markerfacecolor',colors(j,:), ...
				'markersize', 4, ...
				'visible', 'off', ...
				'xdata', smooth_t, ...
				'ydata', smooth_val ...
			);

			handles(end + 1) = line( ...
				'parent',ax, ...
				'color',[0 0 0], ...
				'linestyle','none', ...
				'marker','o', ...
				'markerfacecolor',colors(j,:), ...
				'markersize', 6, ...
				'visible', 'off', ...
				'xdata', actual_t, ...
				'ydata', actual_val ...
			);		
		
		end
		
		%--
		% tie balloons or draw stems
		%--
				
		if parameter.stem || parameter.balloon
			
			%--
			% select linestyle
			%--
			
			if parameter.balloon
				linestyle = ':'; color = 0.5 * ones(1,3);
			else
				linestyle = '-'; color = colors(j,:);
			end
			
			%--
			% draw peak connecting lines
			%--
				
			for i = 1:length(smooth_ix)

				handles(end + 1) = line( ...
					'parent',ax, ...
					'linestyle',linestyle, ...
					'color', color, ...
					'visible', 'off', ...
					'xdata', [actual_t(i), smooth_t(i)], ...
					'ydata', [actual_val(i), smooth_val(i)] ...
				);		

			end
			
		end
	
		%--
		% draw labels
		%--
		
		if parameter.label
			
			for i = 1:length(smooth_ix)

				%--
				% compute peak label string
				%--

				id_str = int2str(clip.id); str = '';

				% TODO: update to deal with tags, events must also display tags
				
				if ~isempty(clip.code)
					str = clip.code;
				end

				str = [str, ' ( ' id_str ' )']	;

				%--
				% display peak label
				%--

				handles(end + 1) = text( ...
					'parent',ax, ...
					'color',colors(j,:), ...
					'clipping','off', ...
					'rotation',45 + 6 * randn(1), ...
					'visible', 'off', ...
					'position', [actual_t(i) + 0.02 * duration, actual_val(i)], ...
					'string', str ...
				);

				text_highlight(handles(end));			

			end
		
		end
		
		%--
		% display rejection as crosshairs
		%--

		if (data.clip{j}.mode == 3)

			handles(end + 1) = line( ...
				'parent',ax, ...
				'color',[1 0 0], ...
				'linestyle','none', ...
				'linewidth',1, ...
				'marker','x', ...
				'markerfacecolor',color, ...
				'markersize',24, ...
				'visible', 'off', ...
				'xdata', actual_t, ...
				'ydata', actual_val ...
			);

			handles(end + 1) = line( ...
				'parent',ax, ...
				'color',[1 0 0], ...
				'linestyle','none', ...
				'linewidth',1, ...
				'marker','o', ...
				'markeredgecolor',[1 0 0], ...
				'markersize',16, ...
				'visible', 'off', ...
				'xdata', actual_t, ...
				'ydata', actual_val ...
			);

		end	
		
		%--
		% display relative threshold
		%--

		if ext.parameter.deviation_test

			% TODO: recover this functionality, information is contained in clip
			
			handles(end + 1) = line( ...
				'parent',ax, ...
				'color', colors(j,:), ...
				'linestyle',':', ...
				'visible', 'off', ...
				'xdata', data.time, ...
				'ydata', ext.parameter.thresh * ones(1,2) ...
			);

		end
		
	end
	
	%--
	% display absolute threshold
	%--
	
	if ext.parameter.thresh_test

		handles(end + 1) = line( ...
			'parent',ax, ...
			'color',0.25 * ones(1,3), ...
			'linestyle',':', ...
			'visible', 'off', ...
			'xdata', data.time, ...
			'ydata', ext.parameter.thresh * ones(1,2) ...
		);

	end
	
	%--
	% display scan page boundaries
	%--
	
	handles(end + 1) = line( ...
		'parent', ax, ...
		'color',0.8 * ones(1,3), ...
		'linestyle','-', ...
		'xdata', [data.time(end), data.time(end)], ...
		'ydata', [-0.1, 1.1] ...
	);
	
end

%--
% trigger resize
%--

figure_resize(par);


%-----------------------------------
% GET_DATA_ENTRY
%-----------------------------------

function out = get_data_entry(in, k, N)

% get_data_entry - copy fields from struct and extract entries
% ------------------------------------------------------------
%
% out = get_data_entry(in, k, N)
%
% Input:
% ------
%  in - input struct
%  k - entry index
%  N - total number
%
% Output:
% -------
%  out - entry struct

% NOTE: this is a fairly general approach, it suggests a packing strategy

%--
% handle input
%--

if (nargin < 3)
	N = [];
end

%--
% loop over fields selecting entry when reasonable
%--

fields = fieldnames(in);

for j = 1:length(fields)

	source = in.(fields{j});

	% NOTE: the first array field dictates the length of the sequence
	
	if isempty(N) && (numel(source) > 1)
		N = numel(source);
	end
	
	if iscell(source) && (numel(source) > 1) && (numel(source) == N)
		out.(fields{j}) = in.(fields{j}){k};
	else
		out.(fields{j}) = in.(fields{j})
	end
	
end


