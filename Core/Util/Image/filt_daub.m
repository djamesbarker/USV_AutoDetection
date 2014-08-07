function [h0,h1] = filt_daub(n,t)

% filt_daub - create daubechies filters
% -------------------------------------
% 
% [h0,h1] = filt_daub(n,t)
%
% Input:
% ------
%  n - length of filters
%  t - phase type (def: 'min')
%
% Output:
% -------
%  h0 - low pass filter
%  h1 - high pass filter

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
% Author: Ramesh Gopinath
% Adapted: Harold Figueroa
%--------------------------------
% $Date: 2004-12-21 19:10:44 -0500 (Tue, 21 Dec 2004) $
% $Revision: 335 $
%--------------------------------

%    [h0,h1] = filt_daub(n,t); 
%
%    Function computes the Daubechies' scaling and wavelet filters
%    (normalized to sqrt(2)).
%
%    Input: 
%       n    : Length of filter (must be even)
%       t : Optional parameter that distinguishes the minimum phase,
%              maximum phase and mid-phase solutions ('min', 'max', or
%              'mid'). If no argument is specified, the minimum phase
%              solution is used.
%
%    Output: 
%       h0 : Minimal phase Daubechies' scaling filter 
%       h1 : Minimal phase Daubechies' wavelet filter 
%
%    Example:
%       n = 4;
%       t = 'min';
%       [h0,h1] = filt_daub(n,t)
%       h0 = 0.4830 0.8365 0.2241 -0.1294
%       h1 = 0.1294 0.2241 -0.8365 0.4830
%
%    Reference: "Orthonormal Bases of Compactly Supported Wavelets",
%                CPAM, Oct.89 
%

%File Name: filt_daub.m
%Last Modification Date: 01/02/96	15:12:57
%Current Version: filt_daub.m	2.3
%File Creation Date: 10/10/88
%Author: Ramesh Gopinath  <ramesh@dsp.rice.edu>
%
%Copyright (c) 2000 RICE UNIVERSITY. All rights reserved.
%Created by Ramesh Gopinath, Department of ECE, Rice University. 
%
%This software is distributed and licensed to you on a non-exclusive 
%basis, free-of-charge. Redistribution and use in source and binary forms, 
%with or without modification, are permitted provided that the following 
%conditions are met:
%
%1. Redistribution of source code must retain the above copyright notice, 
%   this list of conditions and the following disclaimer.
%2. Redistribution in binary form must reproduce the above copyright notice, 
%   this list of conditions and the following disclaimer in the 
%   documentation and/or other materials provided with the distribution.
%3. All advertising materials mentioning features or use of this software 
%   must display the following acknowledgment: This product includes 
%   software developed by Rice University, Houston, Texas and its contributors.
%4. Neither the name of the University nor the names of its contributors 
%   may be used to endorse or promote products derived from this software 
%   without specific prior written permission.
%
%THIS SOFTWARE IS PROVIDED BY WILLIAM MARSH RICE UNIVERSITY, HOUSTON, TEXAS, 
%AND CONTRIBUTORS AS IS AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, 
%BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS 
%FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL RICE UNIVERSITY 
%OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, 
%EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, 
%PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; 
%OR BUSINESS INTERRUPTIONS) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, 
%WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR 
%OTHERWISE), PRODUCT LIABILITY, OR OTHERWISE ARISING IN ANY WAY OUT OF THE 
%USE OF THIS SOFTWARE,  EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
%
%For information on commercial licenses, contact Rice University's Office of 
%Technology Transfer at techtran@rice.edu or (713) 348-6173

%--
% set phase type
%--

if(nargin < 2)
  t = 'min';
end

%--
% check length of filters
%--

if(rem(n,2) ~= 0)
  error('No Daubechies filter exists for ODD length');
end

K = n/2;
a = 1;
p = 1;
q = 1;

h0 = [1 1];

for j  = 1:(K - 1)
	
  a = -a * 0.25 * (j + K - 1)/j;
  h0 = [0 h0] + [h0 0];
  p = [0 -p] + [p 0];
  p = [0 -p] + [p 0];
  q = [0 q 0] + a*p;
  
end

q = sort(roots(q));

qt = q(1:K-1);

%--
% compute depending on phase type
%--

if (t == 'mid')
	
  if rem(K,2)==1,  
    qt = q([1:4:n-2 2:4:n-2]);
  else
    qt = q([1 4:4:K-1 5:4:K-1 n-3:-4:K n-4:-4:K]);
  end
  
end

h0 = conv(h0,real(poly(qt)));
h0 = sqrt(2)*h0/sum(h0);

if (t == 'max')
  h0 = fliplr(h0);
end

if(abs(sum(h0 .^ 2))-1 > 1e-4) 
  error('Numerically unstable for this value of "n".');
end

h1 = rot90(h0,2);
h1(1:2:n)=-h1(1:2:n);
