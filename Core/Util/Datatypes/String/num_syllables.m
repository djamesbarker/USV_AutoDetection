function syllables = num_syllables(str)

% num_syllables - find the number of syllables in a given word
% ------------------------------------------------------------
%
% syllables = num_syllables(str)

%--
% iterate
%--

if iscell(str)
	
	syllables = {};
	
	for k = 1:numel(str)
		syllables{end + 1} = num_syllables(str{k});
	end
	
	return;
	
end

%--
% find number of syllables
%--

ix = is_vowel(str); ix = [0, ix];

% NOTE: number of syllables is number of vowel groups in many cases

syllables = numel(find(diff(ix) > 0));
