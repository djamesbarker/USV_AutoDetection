function out = anagram(in,dict)

% anagram - get anagrams of input string
% --------------------------------------
%
% out = anagram(in,dict)
%
% Input:
% ------
%  in - input string
%  dict - dictionary
%
% Output:
% -------
%  out - anagrams

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

% TODO: consider histogram representation

% TODO: use dictionary structure, containing length and sorted

% TODO: evaluate arithmetic in various types

%-------------------------------------------------
% HANDLE INPUT
%-------------------------------------------------

%--
% set default dictionary
%--

if (nargin < 2)
	dict = dict_def
end

%--
% pre-process dictionary
%--

% NOTE: sort by length, remove long and words with other characters

dict = dict_pre(dict,in)

%-------------------------------------------------
% GET ANAGRAMS
%-------------------------------------------------

% get starting point in dictionary

% recursively chomp letters and build string



%-------------------------------------------------
% DICT_DEF
%-------------------------------------------------

function dict = dict_def

% dict_def - create default dictionary
% ------------------------------------

str = [ ...
	'the quick brown fox jumped over the dog and this other another set simple words vole please placid place ' ...
	'testing this algorithm should done with small dictionary easy compute short time clock rating face yellow ' ...
	'cat dog rat frog rabbit goose ferret duck mean test true false then great greet rate tear grater ' ...
	'comma more emu tye type goad goat load lair rail eerie from mere ream mare green red read raid aid doe ' ...
	'forest tree try let allow west may yam fare fair fail leaf fell felt fig figure figment torment mint lint ' ...
	'element atom moat gloat float hare fear sun son sin pin bin gin tin fin win won wolf old are ear fur ' ...
	'mast err sip ship hip lip list blade glade site sit error moor hoard board heard herd mull mutt mu lure ' ...
	'diahrrea court cart crate create torn worn chute loot hoot dice dictate lactate expect lint please ' ...
	'forward back swing grass vertex dictionary dictate better represent variety ant hog best lye lie tie brie for' ...
];

dict = str_split(str);
	

%-------------------------------------------------
% DICT_PRE
%-------------------------------------------------

function dict = dict_pre(dict,in)

% dict_pre - process dictionary
% -----------------------------
%
% dict = dict_pre(dict,in)
%
% Input:
% ------
%  dict - input dictionary
%  in - input word
%
% Output:
% -------
%  dict - processed dictionary

%--
% sort dictionary by lengths
%--

n = cellfun('length',dict); 

[n,ix] = sort(n);

dict = dict(ix);

%--
% prune dictionary using lengths
%--

% NOTE: find index of first word that exceeds input length

N = find(n > length(in),1);

if (~isempty(N))
	dict = dict(1:N - 1);
end

%--
% prune dictionary by contents
%--

% NOTE: remove words containing letters not part of input

letters = unique(in);

for k = length(dict):-1:1
	
	if (~isempty(setdiff(dict{k},letters)))
		dict(k) = [];
	end
	
end
