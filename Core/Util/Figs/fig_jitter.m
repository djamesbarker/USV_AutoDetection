function fig_jitter(h)

if (nargin < 1)
	h = gcf;
end 

pos = get(h,'position');

set(h,'position',pos + 1);

set(h,'position',pos);

refresh(h);
