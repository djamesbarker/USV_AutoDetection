function flag = text_highlight(h, str, opt)

% text_hightlight - make text highlight
% -------------------------------------
%
%  opt = text_highlight
% 
% flag = text_highlight(h, str, opt)
%
% Input:
% ------
%  h - handle to text object
%  str - command string
%  opt - text highlighting options
%
% Output:
% -------
%  opt - text highlighting options
%  flag - resulting highlight state

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

% TODO: add string property storage

%-----------------------------------------
% SETUP
%-----------------------------------------

%--
% create highlight and text property table
%--

persistent TEXT_FIELD TEXT_PROPERTY;

if isempty(TEXT_FIELD)

	TEXT_FIELD = { ...
		'edge','color','background','linestyle','linewidth','margin','clipping' ...
	};

	% NOTE: this is only needed because we are using different field names
	
	TEXT_PROPERTY = TEXT_FIELD;
	
	TEXT_PROPERTY{1} = 'edgecolor';
	
	TEXT_PROPERTY{3} = 'backgroundcolor';
	
end

%-----------------------------------------
% HANDLE INPUT
%-----------------------------------------

%--
% set default highlight options
%--

if (nargin < 3) || isempty(opt)

	% NOTE: use empty values for any options we don't want to use
	
	switch 1

		%--
		% black text on yellow background highlight with gray border
		%--
		
		case 1
			
			% TODO: create 'auto' mode for edge color that uses text color before highlighting
			
			opt.highlight_edge = 0.8 * [1, 1, 0.6];
			
			opt.highlight_color = [0, 0, 0];
			
			opt.highlight_background = [1, 1, 0.6];
			
			opt.highlight_linestyle = [];
			
			opt.highlight_linewidth = [];
			
			opt.highlight_margin = 3;
			
			opt.highlight_clipping = 'off';
			
		%--
		% dotted red border
		%--
		
		case (3)
			
			opt.highlight_edge = [1 0 0];
			
			opt.highlight_color = [];
			
			opt.highlight_background = [];
			
			opt.highlight_linestyle = ':';
			
			opt.highlight_linewidth = [];
			
			opt.highlight_margin = [];
			
			opt.highlight_clipping = 'off';
			
	end
	
	%--
	% initial state parameter and storage for state
	%--
		
	opt.initial_state = 0;
	
	%--
	% callback and callback mode
	%--
	
	% NOTE: allowed callback modes are 'mathworks' and 'simple'
	
	opt.callback = [];
	
% 	opt.callback_mode = 'mathworks';

	opt.callback_mode = 'simple';
	
	%--
	% output options if needed
	%--

	if ~nargin
		flag = opt; return;
	end

end

%--
% set and check command string
%--

if (nargin < 2) || isempty(str)
	str = 'initialize';
end

commands = {'initialize', 'highlight', 'callback'};

if ~ismember(str, commands)
	return;
end

%--
% catch double click event for text when a callback is defined
%--

if ~isempty(opt.callback)
	
	if (length(h) == 1) && double_click(h)

		% NOTE: extra call to text highlight restores click consumed by
		% callback, there may be a more efficient way to handle this

		text_highlight(h, 'highlight'); str = 'callback';

	end
	
end

%-----------------------------------------
% MAIN SWITCH
%-----------------------------------------

switch str

	case 'initialize'

		%--
		% add empty storage fields to highlight options
		%--
		
		% NOTE: this is a way of protecting certain field states
		
		for k = 1:length(TEXT_FIELD)
			opt.(TEXT_FIELD{k}) = [];
		end

		opt.state = [];
				
		%--
		% update text object
		%--
				
		% TODO: consider a non-clobbering version of this code

		set(h, ...
			'buttondownfcn', 'text_highlight(gco,''highlight'')', ...
			'userdata', opt ...
		);
	
		%--
		% update based on initial state option
		%--
		
		if opt.initial_state
			
			%--
			% update text
			%--
			
			for k = 1:length(h)
				highlight_on(h(k), opt, TEXT_FIELD, TEXT_PROPERTY);
			end
			
			%--
			% refresh figure
			%--
			
			refresh(gcf);
			
		end

	% TODO: allow for direct setting of highlight state
	
	case 'highlight'

		%--
		% get object userdata
		%--
		
		opt = get(h, 'userdata');
		
		%--
		% reset original display of text and update state
		%--

		if opt.state

			%--
			% update ans store state
			%--
			
			opt.state = 0;
			
			set(h, 'userdata', opt);
			
			%--
			% update text 
			%--
			
			for k = 1:length(TEXT_FIELD)
				if ~isempty(opt.(['highlight_', TEXT_FIELD{k}]))
					set(h, TEXT_PROPERTY{k}, opt.(TEXT_FIELD{k}));
				end
			end
				
		%--
		% set text to highlight state
		%--
		
		else

			%--
			% update state
			%--
			
			opt.state = 1;
					
			%--
			% copy initial properties
			%--
			
			for k = 1:length(TEXT_FIELD)
				if ~isempty(opt.(['highlight_', TEXT_FIELD{k}]))
					opt.(TEXT_FIELD{k}) = get(h, TEXT_PROPERTY{k});
				end
			end
						
			%--
			% save state
			%--
			
			set(h, 'userdata', opt);
			
			%--
			% update text
			%--
			
			for k = 1:length(TEXT_FIELD)
				if ~isempty(opt.(['highlight_', TEXT_FIELD{k}]))
					set(h, TEXT_PROPERTY{k}, opt.(['highlight_' TEXT_FIELD{k}]));
				end
			end
			
			%--
			% bring text to front on highlight
			%--
			
			uistack(h, 'top');
			
		end

		%--
		% refresh figure
		%--

		% NOTE: this is a costly operation, however this happens at interaction

		refresh(gcf);

	%-----------------------------------------
	% Execute Callback
	%-----------------------------------------
	
	% NOTE: this code has not been thoroughly tested
	
	case 'callback'
				
		% TEST CODE
		% ---------
		
		% NOTE: inline editing is not easily done using the edit mode,
		% because there is no event associated to the edit change of state
		
		if isempty(opt.callback)
			
			% TEST 1
			
% 			disp(' ');
% 			
% 			disp([upper('callback triggered') ' (TAG: ' get(h,'tag') ')']);
			
			% TEST 2
			
% 			set(h,'editing','on');
						
		end
			
		if ~isempty(opt.callback)
			
			%--
			% string callback
			%--
			
			% NOTE: this is an old way of defining callbacks
			
			if isa(opt.callback, 'char')
				
				eval(opt.callback);
				
			%--
			% function handle callback
			%--
			
			elseif isa(opt.callback, 'function_handle')
				
				% NOTE: this emulates the function handle callback
							
				switch opt.callback_mode
					
					case 'mathworks'
						feval(opt.callback, h, []);
					
					case 'simple'
						feval(opt.callback);
						
				end
				
			%--
			% function handle callback with arguments
			%--
			
			% NOTE: this emulates the function handle callback
			
			elseif iscell(opt.callback)
				
				% NOTE: permit wrapping the function handle in a cell array
	
				if (length(opt.callback) == 1)
					
					feval(fun, h, []);
					
				else
					
					%--
					% separate function from arguments
					%--

					fun = opt.callback{1};

					args = opt.callback(2:end);
							
					%--
					% execute callback according to mode
					%--
					
					switch opt.callback_mode
						
						case 'mathworks'

							% NOTE: this is a hack trying allowing up to four arguments

							switch length(args)

								case (1)
									feval(fun,h,[],args{1});
								case (2)
									feval(fun,h,[],args{1},args{2});
								case (3)
									feval(fun,h,[],args{1},args{2},args{3});
								case (4)
									feval(fun,h,[],args{1},args{2},args{3},args{4});
								otherwise
									warning('Only up to three additional arguments are supported.');

							end
							
						case 'simple'

							% NOTE: this is a hack trying allowing up to four arguments

							switch length(args)

								case (1)
									feval(fun,args{1});
								case (2)
									feval(fun,args{1},args{2});
								case (3)
									feval(fun,args{1},args{2},args{3});
								case (4)
									feval(fun,args{1},args{2},args{3},args{4});
								otherwise
									warning('Only up to three additional arguments are supported.');

							end
							
					end
				
				end

			end
			
		end
		
end



%-----------------------------------------
% HIGHLIGHT_ON
%-----------------------------------------

function highlight_on(h, opt, TEXT_FIELD, TEXT_PROPERTY)

%--
% update state
%--

opt.state = 1;

%--
% copy initial properties
%--

for k = 1:length(TEXT_FIELD)
	
	if ~isempty(opt.(['highlight_', TEXT_FIELD{k}]))
		opt.(TEXT_FIELD{k}) = get(h, TEXT_PROPERTY{k});
	end
	
end

%--
% save state
%--

set(h, 'userdata', opt);

%--
% update text
%--

for k = 1:length(TEXT_FIELD)
	
	if ~isempty(opt.(['highlight_', TEXT_FIELD{k}]))
		set(h, TEXT_PROPERTY{k}, opt.(['highlight_', TEXT_FIELD{k}]));
	end
	
end
