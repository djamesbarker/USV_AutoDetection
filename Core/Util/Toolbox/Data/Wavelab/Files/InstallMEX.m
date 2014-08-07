function InstallMEX

%-------------------
% SETUP
%-------------------

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

global WAVELABPATH

MEX_OK = 1;

files = { ...
	'CPAnalysis' 'WPAnalysis' 'FWT_PO' 'FWT2_PO' 'IWT_PO' ...
	'IWT2_PO' 'UpDyadHi' 'UpDyadLo' 'DownDyadHi' 'DownDyadLo' 'dct_iv' ...
	'FCPSynthesis' 'FWPSynthesis' ...
	'dct_ii' 'dst_ii' 'dct_iii' 'dst_iii' ...
	'FWT_PBS' 'IWT_PBS' ...
	'FWT_TI' 'IWT_TI' ...
	'FMIPT' 'IMIPT' ...
	'FAIPT' 'IAIPT' 'LMIRefineSeq' 'MedRefineSeq' ...
};
	
%-------------------
% CHECK
%-------------------

% NOTE: check that all MEX files are installed, we break if one is missing

for k = 1:length(files)
	
	file = files{k};
	
	if exist(file, 'file') ~= 3
		MEX_OK = 0; break;
	end
	
end

%-------------------
% INSTALL
%-------------------

if ~MEX_OK
	
	disp('WaveLab detects that some or all of your MEX files are not installed,');
	
	R = input('do you want to install them now? [[Yes]/No] \n','s');

	if isempty(R) || strcmpi(R, 'yes') || strcmpi(R, 'y')

		disp('INSTALLING MEX FILES, MAY TAKE A WHILE ...')
		disp(' ')
		disp('WaveLab assumes that your mex compiler is properly installed.')
		disp('In particular, you should be able to call mex.m within matlab')
		disp('to compile a mex file.')
		disp('Consult your system administrator if not.')
		disp(' ')

		eval(sprintf('cd ''%sMEXSource''', WAVELABPATH));

		for k = 1:length(files)

			file = files{k};
			
			disp(sprintf('%s.c', file));
			
			% TODO: consider using 'build_mex'
			
			eval(sprintf('mex %s.c', file));

		end

		Friend = computer; isPC = 0; isMAC = 0;

		if strcmp(Friend(1:2),'PC')
			isPC = 1;
		elseif strcmp(Friend,'MAC2')
			isMAC = 1;
		end

		if isunix,

			!mv CPAnalysis.mex* ../Packets/One-D
			!mv WPAnalysis.mex* ../Packets/One-D
			!mv FWT_PO.mex* ../Orthogonal
			!mv FWT2_PO.mex* ../Orthogonal
			!mv IWT_PO.mex* ../Orthogonal
			!mv IWT2_PO.mex* ../Orthogonal
			!mv UpDyadHi.mex* ../Orthogonal
			!mv UpDyadLo.mex* ../Orthogonal
			!mv DownDyadHi.mex* ../Orthogonal
			!mv DownDyadLo.mex* ../Orthogonal
			!mv dct_iv.mex* ../Packets/One-D
			!mv FCPSynthesis.mex* ../Pursuit
			!mv FWPSynthesis.mex* ../Pursuit
			!mv dct_ii.mex* ../Meyer
			!mv dst_ii.mex* ../Meyer
			!mv dct_iii.mex* ../Meyer
			!mv dst_iii.mex* ../Meyer
			!mv FWT_PBS.mex* ../Biorthogonal
			!mv IWT_PBS.mex* ../Biorthogonal
			!mv FWT_TI.mex* ../Invariant
			!mv IWT_TI.mex* ../Invariant
			!mv FMIPT.mex* ../Median
			!mv IMIPT.mex* ../Median
			!mv FAIPT.mex* ../Papers/MIPT
			!mv IAIPT.mex* ../Papers/MIPT
			!mv LMIRefineSeq.mex* ../Papers/MIPT
			!mv MedRefineSeq.mex* ../Papers/MIPT

		elseif isPC,

			dos(['move CPAnalysis.', mexext, ' ..\Packets\One-D']);
			dos(['move WPAnalysis.', mexext, ' ..\Packets\One-D']);
			dos(['move FWT_PO.', mexext, ' ..\Orthogonal']);
			dos(['move FWT2_PO.', mexext, ' ..\Orthogonal']);
			dos(['move IWT_PO.', mexext, ' ..\Orthogonal']);
			dos(['move IWT2_PO.', mexext, ' ..\Orthogonal']);
			dos(['move UpDyadHi.', mexext, ' ..\Orthogonal']);
			dos(['move UpDyadLo.', mexext, ' ..\Orthogonal']);
			dos(['move DownDyadHi.', mexext, ' ..\Orthogonal']);
			dos(['move DownDyadLo.', mexext, ' ..\Orthogonal']);
			dos(['move dct_iv.', mexext, ' ..\Packets\One-D']);
			dos(['move FCPSynthesis.', mexext, ' ..\Pursuit']);
			dos(['move FWPSynthesis.', mexext, ' ..\Pursuit']);
			dos(['move dct_ii.', mexext, ' ..\Meyer']);
			dos(['move dst_ii.', mexext, ' ..\Meyer']);
			dos(['move dct_iii.', mexext, ' ..\Meyer']);
			dos(['move dst_iii.', mexext, ' ..\Meyer']);
			dos(['move FWT_PBS.', mexext, ' ..\Biorthogonal']);
			dos(['move IWT_PBS.', mexext, ' ..\Biorthogonal']);
			dos(['move FWT_TI.', mexext, ' ..\Invariant']);
			dos(['move IWT_TI.', mexext, ' ..\Invariant']);
			dos(['move FMIPT.', mexext, ' ..\Median ']);
			dos(['move IMIPT.', mexext, ' ..\Median']);
			dos(['move FAIPT.', mexext, ' ..\Papers\MIPT']);
			dos(['move IAIPT.', mexext, ' ..\Papers\MIPT']);
			dos(['move LMIRefineSeq.', mexext, ' ..\Papers\MIPT']);
			dos(['move MedRefineSeq.', mexext, ' ..\Papers\MIPT']);

		elseif isMAC,

			acopy('CPAnalysis.mex', '::Packets:One-D')
			acopy('WPAnalysis.mex' ,'::Packets:One-D')
			acopy('FWT_PO.mex' ,'::Orthogonal')
			acopy('FWT2_PO.mex' ,'::Orthogonal')
			acopy('IWT_PO.mex' ,'::Orthogonal')
			acopy('IWT2_PO.mex' ,'::Orthogonal')
			acopy('UpDyadHi.mex' ,'::Orthogonal')
			acopy('UpDyadLo.mex' ,'::Orthogonal')
			acopy('DownDyadHi.mex' ,'::Orthogonal')
			acopy('DownDyadLo.mex' ,'::Orthogonal')
			acopy('dct_iv.mex' ,'::Packets:One-D')
			acopy('FCPSynthesis.mex' ,'::Pursuit')
			acopy('FWPSynthesis.mex' ,'::Pursuit')
			acopy('FastAllSeg.mex' ,'::Papers:MinEntSeg')
			acopy('dct_ii.mex' ,'::Meyer')
			acopy('dst_ii.mex' ,'::Meyer')
			acopy('dct_iii.mex' ,'::Meyer')
			acopy('dst_iii.mex' ,'::Meyer')
			acopy('FWT_PBS.mex' ,'::Biorthogonal')
			acopy('IWT_PBS.mex' ,'::Biorthogonal')
			acopy('FWT_TI.mex' ,'::Invariant')
			acopy('IWT_TI.mex' ,'::Invariant')
			acopy('FMIPT.mex' ,'::Median')
			acopy('IMIPT.mex' ,'::Median')
			acopy('FAIPT.mex' ,'::Papers:MIPT')
			acopy('IAIPT.mex' ,'::Papers:MIPT')
			acopy('LMIRefineSeq.mex' ,'::Papers:MIPT')
			acopy('MedRefineSeq.mex' ,'::Papers:MIPT')

		end

	end

end

eval(sprintf('cd ''%s''', WAVELABPATH));

clear MEX_OK isPC R


%
%  Part of Wavelab Version 850
%  Built Tue Jan  3 13:20:38 EST 2006
%  This is Copyrighted Material
%  For Copying permissions see COPYING.m
%  Comments? e-mail wavelab@stat.stanford.edu
