function str = string_scramble(str, opt)

% string_scramble - scramble strings, handles lines
% -------------------------------------------------
%
% str = string_scramble(str, opt)
%
% opt = string_scramble
%
% Input:
% ------
%  str - string or lines
%  opt - scramble options
%
% Output:
% -------
%  str - scrambled strings
%  opt - scramble options

% TODO: the handling of punctuation is buggy: for sequences of punctuation, and bracketed punctuation

%--
% handle input
%--

if nargin < 2
	opt.fix_ends = 1; opt.punctuate = 1; opt.tokenize = 1;
end

if ~nargin
	str = opt; return;
end

% NOTE: handle string cell arrays recursively

if iscell(str)
	str = iterate(mfilename, str, opt); return;
end

%--
% scramble string
%--

if isempty(str) 
	return;
end

% NOTE: handle complex strings recursively, split then process then implode

if opt.tokenize
	
	% TODO: improve how punctuation works with marks that do not coincide with a break
	
	if opt.punctuate
		
		pix = find(isstrprop(str, 'punct')); six = find(str == ' ');
		
		for k = numel(pix):-1:1
			if ~ismember(pix(k) + 1, six) && pix(k) < numel(str), pix(k) = []; end
		end
		
		marks = str(pix); str(pix) = ' '; str = strtrim(str);
		
	end
	
	opt.tokenize = 0; str = str_implode(iterate(mfilename, str_split(str), opt)); 
	
	if opt.punctuate
		str = inject(str, marks, pix - (0:length(pix) - 1));
	end
	
	return;

end

% NOTE: there is nothing to do with fixed ends when the string is shorter than 4

if opt.fix_ends
	if length(str) > 3
		str = [str(1), scramble(str(2:end - 1), opt), str(end)];
	end
else
	str = scramble(str, opt);
end


%----------------------
% SCRAMBLE
%----------------------

function str = scramble(str, opt)

%--
% set default options
%--

if nargin < 2
	opt.punctuate = 0; opt.fix_ends = 1;
end

%--
% handle the non-punctuated cases
%--

if ~opt.punctuate
	str = str(randperm(length(str))); return;
end

pix = find(isstrprop(str, 'punct'));

if isempty(pix)
	str = str(randperm(length(str))); return;
end

%--
% handle the punctuated case
%--

pix = [0, pix, numel(str)];

% NOTE: in the case of hyphenated words we do not fix part ends, just the full ends

for k = 1:(numel(pix) - 1)
	ix = (pix(k) + 1):(pix(k + 1) - 1); str(ix) = scramble(str(ix));
end


%----------------------
% INJECT
%----------------------

function out = inject(in, str, pos)

%--
% handle input
%--

if numel(str) ~= numel(pos) 
	error('Injection string and position arrays must have matching lengths.'); 
end

%--
% inject strings
%--

simple = ~iscell(str); pos = [1, pos];

out = '';

% NOTE: the position array has been lengthened, but not the string array

for k = 1:numel(str)

	if simple
		inject = str(k);
	else
		inject = str{k};
	end
	
	out = [out, in(pos(k):pos(k + 1) - 1), inject];
	
end

out = [out, in(pos(end):end)];


