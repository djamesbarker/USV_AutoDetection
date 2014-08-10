function scope = scope_line(ax, varargin)

scope(1) = create_line(ax(1), 'scope_line::1', varargin{:});

% NOTE: in the case of single channel files we have a single scope axes

if length(ax) > 1
	scope(2) = create_line(ax(2), 'scope_line::2', varargin{:});
end
