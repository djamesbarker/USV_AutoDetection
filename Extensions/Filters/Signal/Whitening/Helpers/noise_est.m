function R = noise_est(x, p, w)

if nargin < 3
	w = 0;
end

x = x(:);

N = length(x);

blocks = floor(N / p);

if rem(length(x), p)
	blocks = blocks + 1;
end

pad_len = blocks * p - N;	

x = [x ; zeros(pad_len, 1)];

x = reshape(x, blocks, p);

if w

	w = sum(x.^2, 2);

	x = x ./ repmat(w, 1, p);

end

R = cov(x);

