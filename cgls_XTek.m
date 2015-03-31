function x = cgls_XTek(b, geom, iterations)
%CGLS_XTEK
% An example reconstruction script for the SophiaBeads Datasets
% Reconstruction and Quantification Tutorials. 
% This script can be used as a template to implement own reconstruction
% method.
%
% Reference:
% A. Bjorck, "Numerical Methods for Least Squares Problems",
% SIAM, Philadelphia, 1996.
%
% INPUT:
%   b: Sinogram (Nikon XTek dataset). 
%   geom: Geometry structure array.
%   iterations: Number of iterations to run the CGLS algorithm for.
%
% OUTPUT:
%   x: Image (volume data).
%
% Copyright (c) 2015 Sophia Bethany Coban
% Code is available via the SophiaBeads Datasets project.
% University of Manchester.

% Make sure data is single precision
b = single(b);

% Initialise
x = single(zeros(prod(geom.voxels),1)); % storage for solution

d = CBbackproject(b, geom); % A'*d
normr2 = d'*d;

h = waitbar(0,'Reconstructing SophiaBeads dataset...');
% Iterate.
for i = 1:iterations
    fprintf('Iteration %d -- ', i);
    waitbar(i/iterations,h,['Iteration ' num2str(i)]);
    tic
    Ad = CBproject(d, geom); % A*d
    alpha = normr2/(Ad'*Ad);
    x  = x + alpha*d;
    b  = b - alpha*Ad;
    s  = CBbackproject(b, geom); % A'*s
    
    % Update d vector.
    normr2_new = s'*s;
    beta = normr2_new/normr2;
    normr2 = normr2_new;
    d = s + beta*d;
    toc; 
end
close(h);

% We are not interested in pixel values <0!
x(x<0)=0;

end
