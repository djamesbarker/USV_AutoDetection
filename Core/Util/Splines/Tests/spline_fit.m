function [y, val, flag] = spline_fit(X, n, tag)

db_disp;

%--
% setup objective computation
%--

[rows, cols] = size(X); imx = linspace(1, n, cols); imy = 0:rows-1;

spline_y = ones(1, n + 2)*(rows/2); 

%--
% fit spline
%--

[y, val, flag] = fminsearch(@(y) distance(X, imx, imy, y), spline_y);

%--
% display editable result if needed
%--

if ~nargout || (nargin > 2)
	
	im.x = imx; im.y = imy; im.c = X;
	
	spline_sandbox(y, im, tag);

end


%-------------------------------
% OBJECTIVE_FUN
%-------------------------------

% NOTE: this uses the component spectrogram image

function d = distance(X, imx, imy, spy)


fun = @(x) x.^2;

N = length(imx);

[ignore, yp] = spline_eval(spy, [], N);

d = 0;

for j = 1:N
	
	k = find(min(abs(yp(j) - imy)));
	
	col = X(:, j); row = X(k, :);
	
	new = sum((yp(j) - imy).^2 .* fun(col)') + sum((j - imx).^2 .* fun(row));
	
	d = d + new;
	
end

disp(num2str(d,10));


% NOTE: this uses the component line

function d = distance2(L, imx, spy)

N = length(imx);

[ignore, yp] = spline_eval(spy, [], N);

d = sum((yp - L).^2);

