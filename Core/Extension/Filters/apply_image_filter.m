function B = apply_image_filter(B, ext, context)

% apply_image_filter - apply active image filter
% -----------------------------------------------
% 
% B = apply_image_filter(B, ext, context)
%
% Input:
% ------
%  B - input images
%  ext - image filter
%  context - context
%
% Output:
% -------
%  B - filtered images

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

% NOTE: extension compute functions are expected to handle single images

%------------------------------------------
% HANDLE INPUT
%------------------------------------------

if (nargin < 3) || isempty(context)
	
	context = struct;
	
	% NOTE: get debug flag from extension if possible
	
	if isfield(ext.control, 'debug')
		context.debug = ext.control.debug;
	end

end

% NOTE: get debug flag from extension if possible

if ~isfield(context, 'debug') && isfield(ext.control, 'debug')
	context.debug = ext.control.debug;
end

%--
% check for opacity parameter
%--

% NOTE: no opacity parameter leads to pure filtered image output

if ~isfield(ext.control, 'opacity')
	alpha = 1;
else
	alpha = ext.control.opacity;
end

%--
% get number of images to process and storage format
%--

% NOTE: multiple images are stored in cell arrays or three dimensional arrays

if iscell(B)
	
	nch = length(B); type = 'cells';
	
elseif (ndims(B) == 3)
	
	nch = size(B, 3); type = 'sheets';
	
else	
	
	nch = 1; type = 'single';
	
end

%------------------------------------------
% APPLY FILTER
%------------------------------------------

%--
% apply filter depending on alpha
%--

% FIXME: there is a problem in making filters active before they are first opened

% start = clock;

switch alpha
	
	%--
	% no filtering
	%--
	
	case 0, return;
		
	%--
	% pure filtered image
	%--
	
	case 1
		
		%--
		% handle multiple and single channel displays
		%--
		
		switch type
			
			case 'single', B = ext.fun.compute(B, ext.parameter, context);
				
			case 'cells'
				

				%%% Modified SCK
				for k = 1:nch
					% if smoothing activated then replace
					% original specgram image with smoothed
					% image
					if isfield(ext.control,'meta')
						C = cell(0);
						C{k} = imresize(B{k}, [ext.control.meta.total_height ext.control.meta.pixel_width],'bilinear');
						B{k} = C{k};
					else
						% if not smoothing, just use original spectrogram
						B{k} = ext.fun.compute(B{k}, ext.parameter, context);
					end
				end
                		%%% end SCK
				
			case 'sheets'
				
				for k = 1:nch
					B(:,:,k) = ext.fun.compute(B(:,:,k), ext.parameter, context);
				end
				
		end
		
	%--
	% alpha blended image
	%--
	
	% TODO: implement and access lower level opacity computation

	otherwise
		
		%--
		% handle multiple and single channel displays
		%--

		switch type
			
			case 'single'
				
				B = combine_images('convex', ...
					B, ext.fun.compute(B, ext.parameter, context), alpha ...
				);
			
			case 'cells'
				
                %%% Modified SCK
                % if smoothing activated then replace original spg image with smoothed image
                for k = 1:nch
                    if isfield(ext.control,'meta')
                        C = cell(0);
                        C{1} = imresize(B{1}, [ext.control.meta.total_height ext.control.meta.pixel_width],'bilinear');
                        B{k} = combine_images('convex', ...
                            C{k}, ...
                            ext.fun.compute(C{k}, ext.parameter, context), ...
                            alpha ...
                            );
                    % otherwise just use original spectrogram
                    else
                        B{k} = combine_images('convex', ...
                            B{k}, ...
                            ext.fun.compute(B{k}, ext.parameter, context), ...
                            alpha ...
                            );
                    end
                end
                %%% end SCK
				
			case 'sheets'
				
				for k = 1:nch
					
					B(:,:,k) = combine_images('convex', ...
						B(:,:,k), ...
						ext.fun.compute(B(:,:,k), ext.parameter, context), ...
						alpha ...
					);
				
				end
				
		end
		
end

%--
% coarse profiling info
%--

% elapsed = etime(clock, start); 
% 
% switch (type)
% 	
% 	case ('single'), [m, n] = size(B); k = 1;
% 		
% 	case ('cells'), [m, n] = size(B{k}); k = length(B);
% 		
% 	case ('sheets'), [m, n, k] = size(B);
% 		
% end
% 
% rate = (m * n * k) / (elapsed * 10^6); 
% 
% disp([ ...
% 	'IMAGE FILTER: ', ext.name, ' = ', ...
% 	num2str(elapsed), ' sec (', int2str(m), ' x ', int2str(n), ' x ', int2str(k), ') ', ...
% 	num2str(rate), ' MP' ...
% ]);


%---------------------------------------------------------
% COMBINE_IMAGES
%---------------------------------------------------------

function Y = combine_images(method, X1, X2, param)

% combine_images - combine two images
% -----------------------------------
%
% Y = combine_images(method, X1, X2, param)
%
% Input:
% ------
%  method - combination method
%  X1, X2 - input images
%  param - parameters for combine
%
% Output:
% -------
%  Y - image combination

% TODO: implement coherent parameter passing

% TODO: implement other forms of combining filtered and input images

switch method
	
	case 'convex', Y = ((1 - param) * X1) + (param * X2);
		
	case 'min', Y = min(X1, X2);
		
	case 'max', Y = max(X1, X2);
		
	% NOTE: non-filtered image output for unrecognized methods, send a message
	
	otherwise, Y = X1;
		
end
