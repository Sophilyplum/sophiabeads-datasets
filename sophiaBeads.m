% Script to run SophiaBeads experiments.
% Follows the tutorial as outlined in Section 3 in
% SophiaBeads Datasets Reconstruction and Quantification Tutorials.
%
% Copyright (c) Sophia Bethany Coban
% Code is available via the SophiaBeads Datasets project.
% University of Manchester, 2015.

addpath XTek/ tools/

%%%% Manually modify these variables %%%%
pathname = ''; % Name of path where the dataset is stored e.g. '/media/somefolder/SophiaBeads_64_averaged/'
filename = ''; % Name of the dataset e.g. 'SophiaBeads_64_averaged'
geom_type = '2D'; % Necessary for loading data. Type can be '2D' or '3D' only.
experiment_name = 'CGLS_200slices'; % For naming purposes...
slices = 200; % Only used if geom_type == 3D.
iterations = 12;                     %   
%%%% ------------------------------- %%%%

if ~exist('mex/CBproject_c.mexa64','file') || ~exist('mex/CBbackproject_c.mexa64','file')
    setup; % If no mex files are found, do a setup.
else
    addpath mex/
end

[data,geom] = pre_recon(pathname, filename, geom_type, slices); % Everything up to the reconstruction stage.

fprintf('\nReconstructing the SophiaBeads dataset (%s)...\n',geom_type);
xcgls = cgls_XTek(data, geom, iterations);
xcgls = reshape(xcgls,geom.voxels);
disp('Reconstruction is complete!');

% Plot the reconstructions
if strcmp(geom_type,'2D')
    figure;imagesc(xcgls);set(gca,'XTick',[],'YTick',[]);axis square;colormap gray;
else
    % plot the centre slice in 3D...
    figure;imagesc(xcgls(:,:,floor(slices/2)));set(gca,'XTick',[],'YTick',[]);axis square;colormap gray;
end

volname = write_vol(xcgls, pathname, filename, experiment_name, 'single');
