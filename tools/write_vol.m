function filename_vol = write_vol(vol, pathname, filename, experiment_name, type)
%WRITE_VOL
% This function writes the reconstructed volume as raw float values.
% This is preferred for the Avizo Quantification stage, as explained in the
% SophiaBeads Datasets Reconstruction and Quantification Tutorials.
% 
% INPUT: 
%   vol: Reconstructed volume.
%   pathname: Name of the folder where the volume is to be stored.
%   filename: Name of file to store the volume as.
%   experiment_name: Name of the experiment for reconstructing this volume. 
%                    This is to help distinguish between volumes, avoids
%                    overwriting. NOTE: This can be an emptry string.
%   type: 'single' or 'uint8', etc. NOTE: This has to be a string.
%
% DEFAULT VALUES:
%   experiment_name = ''; (empty string)
%   type = 'single';
%
% OUTPUT:
%   filename_vol: Name of the file the volume is saved as.
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

if nargin<4
    experiment_name = '';
    type = 'single';
end

filename_vol = [filename '_' experiment_name '.vol']; % Modifying this for a nicer name for the volume.

%% Writing to file:

% Open a file in desired path:
fid = fopen([pathname filename_vol], 'w');

% Write the volume as the chosen type.
fwrite(fid, vol, type);
fprintf('The reconstructed volume is written in folder %s.\n', pathname);
fprintf('The volume is saved as %s.\n',filename_vol);

% Closing the file after the volume has been written.
fclose(fid);

end







