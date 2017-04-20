function [data,geom] = pre_recon(pathname, filename, geom_type, slices)
%PRE_RECON
% Function to take care of all the pre-reconstruction steps in one go.
%
% INPUT
%   pathname: Name of path where the files are stored.
%   filename: Name of files to load (name of .xtekct file without the
%             extension).
%   geom_type: '2D' or '3D' cone beam geometry.
%   slices: Number of slices in the z-direction.
%
% OUTPUT:
%   data: Returned Nikon XTek data in single format.
%   geom: Returned geometry structure array.
%
% Copyright (c) 2015 Sophia Bethany Coban
% Code is available via the SophiaBeads Datasets project.
% University of Manchester.

% Load dataset:
fprintf('\nLoading the SophiaBeads dataset (%s)...\n',geom_type);
[data, geom] = load_nikon(pathname, filename, geom_type);

% Cut down the dataset to 1564x1564xslices (these values were picked during the data acquisition of SophiaBeads datasets).
[data,geom]=cutDown_data(data,geom,geom_type,slices);
fprintf('Dataset is cut down to 1564 x 1564 x %d...\n',geom.voxels(3));

% Find and apply correction for CoR:
disp('Applying centre of rotation correction...');
geom = centre_geom(data, geom);

% Vectorize dataset:
data=data(:); 

% OPTIONAL: Apply empirical beam hardening correction (this just amplifies values in data). Uncomment next line.
% data=data.^2;

disp('Pre-reconstruction stage is complete!');
end
