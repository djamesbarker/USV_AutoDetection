function out = page_compute(sound, t, dt, ch, fun, block_size)

nch = length(ch);

%--
% get default block size
%--

if ((nargin < 5) || isempty(block_size))	
	bytes = 2^22; block_size = floor((bytes / 8) / nch);
end

%--
% compute useful fields
%--

blocks = floor(dt / block_size);
		
%--
% initialize loop
%--

out = cell(blocks, nch);

%--
% loop over blocks and compute function for each block
%--

for block = 1:blocks
	
	state = cell(1, nch);
	
	start_time = (block - 1) * block_size;
	
	X = sound_read(sound, 'time', start_time, block_size, ch);
	
	for chix = 1:nch	
		
		[out{block,chix}, state{chix}] = fun{1}(X(:,chix), state{chix}, ch(chix), fun{2:end});

	end
	
end

tmp = empty(out{1,1});

for k = 1:nch
	
	for b = 1:blocks
		
		tmp = [tmp; out{b,k}(:)];
		
	end
	
end

out = tmp;

			
