%EIG_LARGEST   Computes the largest eigenvector and value
%  V=EIG_LARGEST(A,SIGMA)
%  calculates the largest eigenvector V of a square tensor image A via the
%  Power Method. Only 7 iterations are done, this should be sufficient for
%  most images
%
%  [V,LAMBDA]=EIG_LARGEST(A,SIGMA)
%  calculates the largest eigenvector V and value LAMBDA of a square
%  tensor image A via the Power Method.
%
%  DEFAULTS: SIMGA=0, i.e. no tensor smoothing. Otherwise the tensor is
%  smoothed by a Gaussian with width SIGMA. Without smoothing you may get
%  lots of warnings (Divide by zero), so warnings are surpressed for this
%  function.
%
%  See also: DIP_IMAGE/EIG, DIP_IMAGE/SVD

%  Power Method: G.H. Golub, C.F. van Loan in Matrix Computations p.406

% (c)2017, Cris Luengo.
% Based on original DIPlib code: (c)1995-2014, Delft University of Technology.
% Based on original DIPimage code: (c)1999-2014, Delft University of Technology.
%
% Licensed under the Apache License, Version 2.0 (the "License");
% you may not use this file except in compliance with the License.
% You may obtain a copy of the License at
%
%    http://www.apache.org/licenses/LICENSE-2.0
%
% Unless required by applicable law or agreed to in writing, software
% distributed under the License is distributed on an "AS IS" BASIS,
% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
% See the License for the specific language governing permissions and
% limitations under the License.

function [out_ev,out_ew] = eig_largest(A,sigma)
if ~isa(A,'dip_image') || isscalar(A)
   error('Image A must be a tensor image')
end
s = tensorsize(A);
if s(1)~=s(2)
   error('Tensor must be square.')
end
if nargin == 2 % default no smoothing
   A = gaussf(A,sigma);
end

% make initial vector for iteration q=(1,1,1...1)'
q = newtensorim(s(1),imsize(A));
tmp = newim(imsize(A));
tmp.data(:) = 1;
q(:) = tmp;

wa = warning;
warning('off');

% 7 iterations should be sufficient
for k=1:7
   q = A*q;
   q = q./norm(q);
end
out_ev = q;
if  nargout>=2
   out_ew = q'*(A*q);
end

warning(wa);