% Script to run the SophiaBeads Dataset experiments.
% Follows the tutorial as outlined in Section 5 in
% SophiaBeads Datasets Project Documentation and Tutorials.
% Available via http://eprints.ma.man.ac.uk/2290/
%
% Copyright (c) 2015 Sophia Bethany Coban
% Code is available via the SophiaBeads Datasets project.
% University of Manchester.

addpath XTek/ tools/ mex/

%%%% Manually modify these variables %%%%
pathname = '../SophiaBeads_$$_averaged/'; % Name of path where the dataset is stored e.g. '/media/somefolder/SophiaBeads_64_averaged/'.
filename = 'SophiaBeads_$$_averaged'; % Name of the dataset e.g. 'SophiaBeads_64_averaged'
geom_type = '2D'; % Necessary for loading data. Type can be '2D' or '3D' only.
experiment_name = 'CGLS_200slices'; % For naming purposes...
slices = 200; % Only used if geom_type == 3D.
iterations = 12;                     %   
%%%% ------------------------------- %%%%


% setup;    % Setup the mex files.
            % NOTE: You do not need to run this if the mex files already exist.
            %       For more info, type 'help setup' on the command window.

[data,geom] = pre_recon(pathname, filename, geom_type, slices); % Everything up to the reconstruction stage.

fprintf('\nReconstructing the SophiaBeads dataset (%s)...\n',geom_type);
xcgls = cgls_XTek(data, geom, iterations);
xcgls = reshape(xcgls,geom.voxels);
disp('Reconstruction is complete!');

% Plot the reconstructions
if strcmp(geom_type,'2D')
    figure;imagesc(xcgls);set(gca,'XTick',[],'YTick',[]);axis square;colormap gray;
else
    % plot the centre slice in 3D
    figure;imagesc(xcgls(:,:,floor(slices/2)));axis square;axis off;colormap gray;
    % plot the entire volume -- view horizontal slices
    scrollView(xcgls,3);
    % plot the entire volume -- view verical slices.
    scrollView(xcgls,1);
end

% Write the reconstructed volume in the same path. 
volname = write_vol(xcgls, pathname, filename, experiment_name, 'single');
