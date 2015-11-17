function centre = find_centre(data, geom)
%FIND_CENTRE
% Function to find the centre of rotation of the central slice for the
% Nikon XTek cone beam scan data
%
% INPUT:
%   data: Nikon XTek cone beam scan data.
%   geom: Geometry structure array
%
% OUTPUT:
%   centre: Centre of rotation value to be added to the geometry
%
% Reference:
% T. Liu - "Direct central ray determination in computed microtomography",
% Optical Engineering, April 2009.
%
% Copyright (c) 2015 Sophia Bethany Coban, William Michael Thompson and Nicola Wadeson
% Code is available via the SophiaBeads Datasets project.
% University of Manchester.

% Set up coordinate grids for testing the fit to data
[alpha, s] = meshgrid(geom.angles,geom.dets.y);

% Wrap grids in the angular direction to avoid value out of range errors
alpha = [(alpha - 2*pi) alpha (alpha + 2*pi)];
s = repmat(s,1,3);
test_data = double(repmat(data,1,3));

% Start search using midpoint at zero
midpoint = 0;
% Vector of precision values to search at
precision = [1 0.1 0.01 0.001 0.0001];

for i = 1:length(precision)
    
    COR = (midpoint - 10*precision(i)):precision(i):(midpoint + 10*precision(i)); % values for centre of rotation
    M = zeros(length(COR),1);
    
    for j = 1:length(COR)
        
        gamma = atan(geom.dets.y / geom.d_sd);   % angle of each ray relative to theoretical central ray    
        gamma_c = atan(COR(j) / geom.d_sd); % angle of assumed centre of rotation to central ray
        gamma_i = gamma - gamma_c;
        beta = 2 * gamma_i + pi;
        
        s2 = geom.d_sd * tan(2 * gamma_c - gamma);
        s2 = repmat(s2, 1, length(geom.angles));
        
        angles = repmat(geom.angles', geom.dets.ny, 1) + repmat(beta, 1, length(geom.angles));
        test = interp2(alpha, s, test_data, angles, s2, 'linear', 0);
        
        nonzero = find(test > 0);
        % We want the number of non-zero values for the average, not the sum of their positions
        M(j) = sum((test(nonzero) - data(nonzero)).^2)*(1/length(nonzero));
    end
    
    [~, indM] = min(M);   % minimum value and index
    midpoint = COR(indM);   % set midpoint for next search
end

% transform centre to required value
centre = midpoint * geom.source.x / geom.d_sd;
