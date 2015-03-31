function filename_vol = write_vol(vol, pathname, filename, recon_method, type)
%WRITE_VOL
% This function writes the reconstructed volume as raw float values.
% This is preferred for the Avizo Quantification stage, as explained in the
% SophiaBeads Datasets Reconstruction and Quantification Tutorials.
% 
% INPUT: 
%   vol: Reconstructed volume.
%   pathname: Name of the folder where the volume is to be stored.
%   filename: Name of file to store the volume as.
%   recon_method: Name of the method used to reconstruct this volume. This
%                   is to help distinguish between volumes -- avoids over-
%                   writing. NOTE: This can be an emptry string (use '').
%   type: 'single' or 'uint8', etc. NOTE: This has to be a string.
%
% DEFAULT VALUES:
%   recon_method = ''; (empty string)
%   type = 'single'
%
% OUTPUT:
%   filename_vol: Name of the file the volume is saved as.
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

if nargin<4
    recon_method = '';
    type = 'single';
end

filename_vol = [filename '_' recon_method '.vol']; % Modifying this for a nicer name for the volume.

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







