function [out]=olam_conv2(a,b,shape)
% [out] = fftolam(a,b)
% Simple Overlap-add method FFT-based 2D convolution
% INPUT
% a:     first image (2D double matrix)
% b:     second image (2D double matrix)
% OUTPUT
% out:   2D convolution of a and b matrices: out = conv2(a,b);

if nargin < 2
	error 'Not enough input arguments';
end

if nargin < 3
	shape = 'full';
end

[ax,ay]       = size(a);
[bx,by]       = size(b);
dimx          = ax+bx-1;
dimy          = ay+by-1;
nfftx         = dimx;
nffty         = dimy;
Lx            = nfftx-bx+1;
Ly            = nffty-by+1;
B             = fft2(b,nfftx,nffty);
out           = zeros(dimx,dimy);
x0 = 1;
while x0 <= ax
	x1   = min(x0+Lx-1,ax);
	y0   = 1;
	endx = min(dimx,x0+nfftx-1);
	while y0 <= ay
		y1                   = min(y0+Ly-1,ay);
		endy                 = min(dimy,y0+nffty-1);
		X                    = fft2(a(x0:x1,y0:y1),nfftx,nffty);
		Y                    = ifft2(X.*B);
		out(x0:endx,y0:endy) = out(x0:endx,y0:endy)+Y(1:(endx-x0+1),1:(endy-y0+1));
		y0                   = y0+Ly;
	end
	x0 = x0+Lx;
end
if ~(any(any(imag(a)))||any(any(imag(b))))
	out=real(out);
end

hb = ceil(0.5 * (size(b) - 1));
hbx = hb(1);
hby = hb(2);

xodd = mod(bx,2)~=0;
yodd = mod(by,2)~=0;

if strcmp(shape, 'same')
	if xodd
		out = out(hbx + 1:end - hbx, :);
	else
		out = out(hbx + 1:end - hbx + 1, :);
	end
	
	if yodd
		out = out(:, hby + 1:end - hby);
	else
		out = out(:, hby + 1:end - hby + 1);
	end
end

if strcmp(shape, 'valid')
	if xodd
		out = out(bx:end - bx + 1, :);
	else
		out = out(bx:end - bx + 1, :);
	end
	
	if yodd
		out = out(: ,by:end - by + 1);
	else
		out = out(: ,by:end - by + 1);
	end
end
