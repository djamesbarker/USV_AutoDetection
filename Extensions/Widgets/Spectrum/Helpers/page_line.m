function [center, low, high] = page_line(ax, varargin)

center = create_line(ax, 'page_line', varargin{:});

low = create_line(ax, 'low_page_line', varargin{:}, 'linestyle', ':');

high = create_line(ax, 'high_page_line', varargin{:}, 'linestyle', ':');

if nargout < 3
	low = [low, high];
end
