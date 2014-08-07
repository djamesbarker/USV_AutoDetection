function [F,d] = figs_tex(h,opt,d)

% figs_tex - save figs as LaTeX figures
% -------------------------------------
%
% [F,d] = figs_tex(h,opt,d)
%
% Input:
% ------
%  h - figure handles
%  opt - latex and eps options
%  d - destination directory (def: uiputfile)
%
% Output:
% -------
%  F - names of tex files created
%  d - destination directory

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

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 1.22 $
% $Date: 2003-02-09 21:29:41-05 $
%--------------------------------

%--
% set filesep string
%--

sep = filesep;

if (sep == '\')
	sep = '/';
end

%--
% set tex options
%--

if ((nargin < 2) | isempty(opt))
	opt.psfrag = 1;
	opt.preview = 1;
	opt.view = 1;
	opt.eps = 'depsc';
end

%--
% set figure handles
%--

if ((nargin < 1) | isempty(h))
	h = get_figs;
end


%--
% set destination directory
%--

if ((nargin < 3) | isempty(d))
	
	%--
	% get filename for first figure
	%--
	
	data = get(h(1),'userdata');
	
	%--
	% set output directory
	%--

	pi = pwd;
	pf = fig_path;
	
	if (~isempty(pf))
		cd(pf);
		[t,d] = uiputfile([data.fig.name '.tex'],'Select destination directory:');
		if (isstr(d))
			fig_path(d);
		else
			return;
		end
		cd(pi);
	else
		[t,d] = uiputfile([data.fig.name '.tex'],'Select destination directory:');
		if (isstr(d))
			fig_path(d);
		else
			return;
		end
	end
	
	%--
    % return on cancel
 	%--
	
    if (~t)
		disp(' ');
		warning('No files were created because ''uigetfile'' was cancelled.');
		disp(' ');
	end
	
end

%--
% apply psfrag replacements
%--

if (opt.psfrag)
	try
		for k = 1:length(h)
			[T{k},R{k},A{k}] = fig_psfrag(h(k));
		end
	catch
		tmp = error_dialog('Try turning off PSFrag.');
		waitfor(tmp);
		return;
	end
end

%--
% create eps files
%--

[E,d] = figs_eps(h,opt.eps,d);
	
%--
% reset original text objects
%--

if (opt.psfrag)
	for k = 1:length(h)
		fig_psfrag(h(k),T{k},R{k});
	end
end

%--
% create label names and filenames
%--

% get names from eps filenames

L = file_ext(E);
F = file_ext(E,'tex');

if (isstr(F))
	E = {E};
	L = {L};
	F = {F};
end

%--
% create latex files for figure input and preview
%--

for k = 1:length(h)
	
	%--
	% create figure input file
	%--
	
	% open text file for writing
	
	fid = fopen(['' d F{k} ''],'wt');
	if (fid == -1)
		warning(['Error opening file''' d F{k} '']);
	end
	
	% get captions
	
	short = fig_short(h(k));
	caption = fig_caption(h(k));
	
	% figure environment string
	
	S = '';
	S = [S '\\begin{figure}[tbhp!]\n'];
	S = [S '\t\\centering\n'];
	if (opt.psfrag)
		for j = 1:length(T{k})
			S = [S '\t\\psfrag{' T{k}{j} '}' A{k}{j} '{' strrep(R{k}{j},'\','\\') '}\n'];
		end
	end
	S = [S '\t\\includegraphics[width = \\textwidth]{figures' sep E{k} '}\n'];	
	S = [S '\t\\caption[' strrep(short,'\','\\') ']{\n'];
	S = [S str_indent(str_wrap(strrep(caption,'\','\\')),2) '\n'];
	S = [S '\t}\n'];
	S = [S '\t\\label{fig:' L{k} '}\n'];	
	S = [S '\\end{figure}\n'];
	
	% write and close file
	
	fprintf(fid,S);
	fclose(fid);
	
	%--
	% create preview file
	%--
	
	if (opt.preview)
		
		G{k} = strrep(F{k},'.','_preview.');
		
		% open text file for writing
		
		fid = fopen(['' d G{k} ''],'wt');	
		if (fid == -1)
			warning(['Error opening file''' d F{k} '']);
		end
		
		% figure preview string
		
		S = '';
		S = [S '\\documentclass[12pt]{article}\n\n'];
		
		S = [S '\\usepackage{amsmath,amssymb,latexsym}\n'];
		S = [S '\\usepackage{graphicx}\n'];
		
		if (opt.psfrag)
			S = [S '\\usepackage{psfrag}\n\n'];
		else
			S = [S '\n'];
		end
		
		% later add option to include a specific style file
		
% 		S = [S '\\input{thesis.sty}\n\n'];
		
		S = [S '\\begin{document}\n\n'];
		
		S = [S '\\begin{figure}[tbhp!]\n'];
		S = [S '\t\\centering\n'];	
		
		if (opt.psfrag)
			for j = 1:length(T{k})
				S = [S '\t\\psfrag{' T{k}{j} '}' A{k}{j} '{' strrep(R{k}{j},'\','\\') '}\n'];
			end
		end
		
		S = [S '\t\\includegraphics[width = \\textwidth]{' E{k} '}\n'];	
		S = [S '\t\\caption[' strrep(short,'\','\\') ']{\n'];
		S = [S str_indent(str_wrap(strrep(caption,'\','\\')),2) '\n'];
		S = [S '\t}\n'];
		S = [S '\t\\label{fig:' L{k} '}\n'];	
		S = [S '\\end{figure}\n\n'];
		
		S = [S '\\end{document}\n'];
		
		% write and close file
		
		fprintf(fid,S);
		fclose(fid);
		
		%--
		% display preview file
		%--
		
		% move to directory containing figure
		
		di = pwd;
		cd(d);
		
		% run latex multipl times to get everything right ...
		
		eval(['!latex -quiet ' G{k}]);
		eval(['!latex -quiet ' G{k}]);
		eval(['!latex -quiet ' G{k}]);
		
		% convert to ps and display ps
		
		eval(['!dvips -q -Ppdf ' file_ext(G{k},'dvi')]); 
		eval(['!' file_ext(G{k},'ps')]);
		
		% delete auxiliary files
		
		eval('!del *.aux');
		eval('!del *.log');
		eval('!del *.dvi');
		
		% return to initial directory
		
		cd(di);
	
	end
	
end

%--
% output string
%--

if (length(F) == 1)
	F = F{1};
end

