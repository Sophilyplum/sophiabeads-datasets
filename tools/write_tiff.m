function foldername = write_tiff(vol, pathname, filename, experiment_name, voxels, type)
%WRITE_TIFF
% Function to write the reconstructed volume as a set of tiff images.
% Each tiff image is a slice in the z-direction.
%
% INPUT: 
%   vol: Reconstructed volume.
%   pathname: Name of the folder where the volume is to be stored.
%   filename: Name of file to store the volume as.
%   experiment_name: Name of the experiment for reconstructing this volume. 
%                    This is to help distinguish between volumes, avoids
%                    overwriting. NOTE: This can be an emptry string.
%   voxels: Size of the volume.
%   type: 'uint8' or 'uint16'. NOTE: This has to be a string.
%
% DEFAULT VALUES:
%   experiment_name = ''; (empty string)
%   voxels = [1564 1564 2000]; (2000 slices)
%   type = 'uint16';
%
% OUTPUT:
%   foldername: Name of folder the tiff files are saved in.
%
% Copyright (c) 2015 Sophia Bethany Coban
% Code is available via the SophiaBeads Datasets project.
% University of Manchester.

%% Quick error checking:

% pathname has to point to a folder:
if ~strcmp(pathname(end),'/')
    pathname = [pathname '/'];
    fprintf('WARNING: The input string pathname has to point to a folder. String has now been modified.\n');
end

%% Default values:

foldername = [filename '_' experiment_name]; % Modifying this for a nicer name for volume.

if nargin<4
    voxels = [1564, 1564, 2000]; % Full size of SophiaBeads volumes.
    experiment_name = '';
    foldername = filename;
    type = 'uint16';
end

%% Write to file:

% First create a folder in the path:
mkdir([pathname foldername])

vol = vol(:) - min(vol);

if strcmp(type,'uint8')
    vol = vol*(255/max(vol)); % scale to max of uint8.
    type_is_uint8 = true;
else
    vol = vol*(65535/max(vol)); % scale to max of uint16.
    type_is_uint8 = false;
end

vol = reshape(vol,voxels);

% write projection data
for i = 1:voxels(3)
    data = vol(:,:,i);
    data = data(:,end:-1:1)';
    
    if type_is_uint8
        data = uint8(data); % write as uint8.
    else
        data = uint16(data); % else, uint16.
    end
    
    imwrite(data, [pathname foldername '/' foldername '_' dec2base(i,10,4) '.tif']);
end

fprintf('Tiff files are written in folder %s.\n', pathname);
end
