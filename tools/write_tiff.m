function write_tiff(vol, pathname, filename, recon_method, voxels, type)
%WRITE_TIFF
% Function to write the reconstructed volume as a set of tiff images.
% Each tiff image is a slice in the z-direction.
%
% INPUT: 
%   vol: Reconstructed volume.
%   pathname: Name of the folder where the volume is to be stored.
%   filename: Name of file to store the volume as.
%   recon_method: Name of the method used to reconstruct this volume. This
%                   is to help distinguish between volumes -- avoids over-
%                   writing. NOTE: This can be an emptry string (use '').
%   voxels: Size of the volume.
%   type: 'uint8' or 'uint16'. NOTE: This has to be either 8 or 16.
%
% DEFAULT VALUES:
%   recon_method = ''; (empty string)
%   voxels = [1564 1564 2000] (2000 slices)
%   type = 16 (uint16)
%
% OUTPUT:
%   none.
%
% Copyright (c) Sophia Bethany Coban
% Code is available via the SophiaBeads Datasets project.
% University of Manchester, 2015.

%% Quick error checking:

% pathname has to point to a folder:
if ~strcmp(pathname(end),'/')
    pathname = [pathname '/'];
    fprintf('WARNING: The input string pathname has to point to a folder. String has now been modified.\n');
end

%% Default values:

filename = [filename '_']; % Modifying this for a nicer name for volume.

if nargin<4
    voxels = [1564, 1564, 2000]; % Full size of SophiaBeads volumes.
    recon_method = '';
    type = 16;
    filename = filename(1:end-1);
end

%% Write to file:

vol = vol(:) - min(vol);

if type == 8
    vol = vol*(255/max(vol)); % scale to max of uint8.
else
    vol = vol*(65535/max(vol)); % scale to max of uint16.
end

vol = reshape(vol,voxels);

% write projection data
for i = 1:voxels(3)
    data = vol(:,:,i);
    data = data(:,end:-1:1)';
    
    if type == 8
        data = uint8(data); % write as uint8.
    else
        data = uint16(data); % else, uint16.
    end
    
    imwrite(data, [pathname filename recon_method '_' dec2base(i,10,4) '.tif']);
end

fprintf('Tiff files are written in folder %s.\n', pathname);
end
