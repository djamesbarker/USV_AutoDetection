function [files, destination] = build

clear fast_specgram_mex_double;

clear fast_specgram_mex_single;

%--
% build double precision DLL
%--

opt = build_mex;

opt.outname = 'fast_specgram_mex_double';

build_mex( ...
    '../fast_specgram_mex.c', ...
    '-lfftw3', ...
    opt ...
);

%--
% build single precision DLL
%--

opt = build_mex;

opt.cflags = {'-DFLOAT'}; opt.outname = 'fast_specgram_mex_single';

build_mex( ...
    '../fast_specgram_mex.c', ...
    '-lfftw3f', ...
    opt ...
);

movefile(['*.', mexext], '../../private');

%--
% report created files and destination
%--

% TODO: the destination is redundant, it should not be needed as output

par = fileparts(fileparts(pwd));

destination = [par, filesep, 'private'];

% NOTE: the files to consider are files after they've been installed

files = { ...
	[destination, filesep, 'fast_specgram_mex_double.', mexext], ...
	[destination, filesep, 'fast_specgram_mex_single.', mexext] ...
};
