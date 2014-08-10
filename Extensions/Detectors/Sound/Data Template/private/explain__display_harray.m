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

% TODO: proper time display

% TODO: recreate previous display, consider configuration parameters

% TODO: consider other layouts, distribution display

%--
% get relevant information from context
%--

parameter

channels = context.page.channels;

%--
% create clip colors
%--

colors = plot_colors(length(data.clip));

%--
% diplay explain data
%--

handles = [];

for k = 1:length(channels)
	
	%--
	% find container axes
	%--
	
	ax = findobj(par,'type','axes','tag',int2str(channels(k)));
	
	if (isempty(ax))
		continue;
	end
	
	%--
	% find auxilliary axes
	%--
	
	dist_ax = findobj(par,'type','axes','tag',['dist_', int2str(channels(k))]);

	%--
	% display channel explain data
	%--

	for j = 1:length(data.correlation)
		
		%--
		% get clip
		%--
		
		clip = data.clip{j};
		
		%--
		% compute time grid
		%--

		% NOTE: this is precise
		
		time = linspace(data.time(1), data.time(2), length(data.correlation{j}) + 1);
		
		duration = diff(data.time);
		
		time = time(1:(end - 1));
		
		%--
		% get peak indexes
		%--
		
		smooth_ix = data.smooth_peaks{j};
		
		corr_ix = data.corr_peaks{j};
		
		%--
		% display actual correlation
		%--

% 		handles(end + 1) = line( ...
% 			'parent', ax, ...
% 			'color', colors(j,:) + .6*(1 - colors(j,:)) , ...
% 			'linestyle', ':', ...
% 			'visible', 'on', ...
% 			'xdata', time, ...
% 			'ydata', data.correlation{j} ...
% 		);
	
		%--
		% display smooth correlation
		%--

		handles(end + 1) = line( ...
			'parent', ax, ...
			'color', colors(j,:), ...
			'visible', 'on', ...
			'xdata', time, ...
			'ydata', data.smooth{j} ...
		);
	
		%--
		% display peaks
		%--
		
		corr_t = time(corr_ix); smooth_t = time(smooth_ix);
		
		corr_val = data.correlation{j}(corr_ix); smooth_val = data.smooth{j}(smooth_ix);
		
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
			'xdata', corr_t, ...
			'ydata', corr_val ...
		);		
	
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
				'xdata', corr_t, ...
				'ydata', corr_val ...
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
				'xdata', smooth_t, ...
				'ydata', smooth_val ...
			);

		end	
		
		%--
		% draw connecting lines and text
		%--
		
		for jj = 1:length(smooth_ix)
			
			%--
			% link peaks
			%--

			handles(end + 1) = line( ...
				'parent',ax, ...
				'linestyle',':', ...
				'color', 0.5 * ones(1,3), ...
				'visible', 'off', ...
				'xdata', [corr_t(jj), smooth_t(jj)], ...
				'ydata', [corr_val(jj), smooth_val(jj)] ...
			);		
		
			%--
			% compute peak label string
			%--

			id_str = int2str(clip.id); str = '';
			
			annotation = get_browser(get_active_browser, 'annotation');

			if (~isempty(clip.code) && ~isempty(annotation.view))
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
				'position', [corr_t(jj) + 0.01*duration, corr_val(jj)], ...
				'string', str ...
			);

			text_highlight(handles(end));			
			
			
		end
		
		%--
		% display distribution
		%--
		
		dist = hist_1d(data.correlation{j});
		
		range = fast_min_max(data.correlation{j});
		
		plot_vals = linspace(range(1), range(2), length(dist));
		
		tag = ['channel_', int2str(channels(k)), '_clip_', int2str(j), '_dist'];
		
		dist_line = findobj(par,'type','line','tag',tag);
		
		if isempty(dist_line)
			
			handles(end + 1) = line( ...
				'parent', dist_ax, ...
				'color', colors(j,:), ...
				'xdata', dist, ...
				'ydata', plot_vals, ...
				'tag', tag ... 
			);
		
		else
			
			dist = dist + get(dist_line, 'xdata');
			
			set(dist_line, ...
				'xdata', dist ...
			);
		
		end

	end
	
	if (data.parameter.thresh_test)

		handles(end + 1) = line( ...
			'parent',ax, ...
			'color',0.2 * ones(1,3), ...
			'linestyle',':', ...
			'visible', 'off', ...
			'xdata', data.time, ...
			'ydata', data.parameter.thresh * ones(1,2) ...
		);
	
		handles(end + 1) = line( ...
			'parent',dist_ax, ...
			'color',0.2 * ones(1,3), ...
			'linestyle',':', ...
			'visible', 'off', ...
			'xdata', [0 1], ...
			'ydata', data.parameter.thresh * ones(1,2) ...
		);

	end
	
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





 
% %-------------------------------------------------------
% % OLD EXPLAIN
% %-------------------------------------------------------
% 
% 
% 		%--
% 		% clear display and create axes array
% 		%--
% 
% 		if (kk == 1)
% 
% 			figure(explain);
% 
% 			clf;
% 
% 			ax = axes_array(nch,1,[],explain);
% 
% 			for k = 1:nch
% 				set(ax(k), ...
% 					'box','on', ...
% 					'tag',int2str(ch(k)) ...
% 					);
% 				hold(ax(k),'on');
% 			end
% 
% 		end
% 
% 	end
% 
% 	% 				figure(explain);
% 
% 	%--
% 	% display normalized correlation and smooth
% 	%--
% 
% 	dax = findobj(explain,'type','axes','tag',int2str(ch(j)));
% 
% 	% 				axes(dax);
% 
% 	color = colors(kk,:);
% 
% 	% NOTE: this should be turned off whenever we have multiple templates
% 
% 	% 				plot(t0 + tj, C0j,':','color',color);
% 
% 	line(t0 + tj, Cj, ...
% 		'parent',dax, ...
% 		'linestyle','-', ...
% 		'color',color ...
% 	);
% 
% 	%--
% 	% display zero
% 	%--
% 
% 	t12 = [t0, t0 + tj(end)];
% 
% 	%--
% 	% display mean and deviation if needed
% 	%--
% 
% 	if (param.deviation_test)
% 
% 		% 					plot(t12,[c c],'color',color);
% 
% 		line(t12,(c + param.deviation*s) * ones(1,2), ...
% 			'parent',dax, ...
% 			'color',color, ...
% 			'linestyle',':' ...
% 			);
% 
% 		line(t12,(c - param.deviation*s) * ones(1,2), ...
% 			'parent',dax, ...
% 			'color',color, ...
% 			'linestyle',':' ...
% 			);
% 
% 	end
% 
% 	%--
% 	% display threshold if needed
% 	%--
% 
% 	if (param.thresh_test)
% 
% 		tmp = 0 * ones(1,3);
% 
% 		line(t12,param.thresh * ones(1,2), ...
% 			'parent',dax, ...
% 			'color',tmp, ...
% 			'linestyle',':' ...
% 			);
% 
% 	end
% 
% 	%--
% 	% display peaks and text
% 	%--
% 
% 	if (~isempty(pix))
% 
% 		t12v = t0 + tj;
% 
% 		%--
% 		% display selected peaks on smooth and raw correlation sequence
% 		%--
% 
% 		% NOTE: we could use the size of the ballons to
% 		% indicate the correlation values
% 
% 		tmp = line(t12v(pix),pv, ...
% 			'parent',dax, ...
% 			'color',[0 0 0], ...
% 			'linestyle','none', ...
% 			'marker','o', ...
% 			'markerfacecolor',color, ...
% 			'markersize',4 ...
% 			);
% 
% 		tmp = line(t12v(p0ix),p0v, ...
% 			'parent',dax, ...
% 			'color',[0 0 0], ...
% 			'linestyle','none', ...
% 			'marker','o', ...
% 			'markerfacecolor',color, ...
% 			'markersize',8 ...
% 			);
% 
% 		%--
% 		% display rejection as crosshairs
% 		%--
% 
% 		if (param.templates.clip(kk).mode == 3)
% 
% 			tmp = line(t12v(p0ix),p0v, ...
% 				'parent',dax, ...
% 				'color',[1 0 0], ...
% 				'linestyle','none', ...
% 				'linewidth',1, ...
% 				'marker','x', ...
% 				'markerfacecolor',color, ...
% 				'markersize',24 ...
% 				);
% 
% 			tmp = line(t12v(p0ix),p0v, ...
% 				'parent',dax, ...
% 				'color',[1 0 0], ...
% 				'linestyle','none', ...
% 				'linewidth',1, ...
% 				'marker','o', ...
% 				'markeredgecolor',[1 0 0], ...
% 				'markersize',16 ...
% 				);
% 
% 		end
% 
% 		%--
% 		% display correlation values and peak matching scope
% 		%--
% 
% 		for k = 1:length(pix)
% 
% 			% TODO: display non selected peaks with a single line like this one, perhaps in a very light gray
% 
% 			%--
% 			% link peaks
% 			%--
% 
% 			line([t12v(p0ix(k)), t12v(pix(k))], [p0v(k), pv(k)], ...
% 				'parent',dax, ...
% 				'linestyle',':', ...
% 				'color', 0.5 * ones(1,3) ...
% 				);
% 
% 			%--
% 			% display correlation values
% 			%--
% 
% 			tix = p0ix(k);
% 
% 			% NOTE: 'kk' is our template index
% 
% 			tmp = param.templates.clip(kk);
% 
% 			id_str = int2str(tmp.id);
% 
% 			str = '';
% 
% 			% NOTE: check whether parent is displaying
% 			% annotations, this is convenient hack and should
% 			% be removed ... then again so is most of this code
% 
% 			tmp2 = get(sys.parent,'userdata');
% 
% 			if (~isempty(tmp.code) && ~isempty(tmp2.browser.annotation.view))
% 				str = tmp.code;
% 			end
% 
% 			str = [str, ' ( ' id_str ' )'];
% 
% 			% 						if (~isempty(tmp.mode))
% 			%
% 			% 							switch (tmp.mode)
% 			% 								case (0)
% 			% 									mode_str = 'ignore';
% 			% 								case (1)
% 			% 									mode_str = 'keep (ex)';
% 			% 								case (2)
% 			% 									mode_str = 'keep';
% 			% 								case (3)
% 			% 									mode_str = 'reject';
% 			% 							end
% 			%
% 			% 							mode_str = upper(mode_str);
% 			%
% 			% 							str2{1} = str;
% 			% 							str2{2} = mode_str;
% 			%
% 			% 							str = str2;
% 			%
% 			% % 							if (~isempty(str))
% 			% % 								str = [str, ' ', mode_str];
% 			% % 							else
% 			% % 								str = mode_str;
% 			% % 							end
% 			%
% 			% 						end
% 
% 			% NOTE: the random rotation makes multiple hits salient
% 
% 			tmp = text( ...
% 				t12v(tix) + 0.01*bt, p0v(k),str, ...
% 				'parent',dax, ...
% 				'color',color, ...
% 				'clipping','off', ...
% 				'rotation',45 + 6*randn(1) ...
% 				);
% 
% 			text_highlight(tmp);
% 
% 			%--
% 			% display peak matching scope
% 			%--
% 
% 			% NOTE: leave this out until later, change to line
% 
% 			% 						plot(t12v([pix(k) - pw(1,k), pix(k) + pw(2,k)]),Cj(pix(k)) * ones(1,2),'-+','color',0.5 * ones(1,3));
% 
% 		end

