function vol_soln = read_vol(pathname, filename, experiment_name, voxels, slices, slice_choice, full_read)
%READ_VOL
% Function that reads a reconstructed volume. This function calls a
% subroutine that allows for a slice or certain number of slices to be read
% rather than a full volume.
%
% INPUT:
%   pathname: Name of path where the files are stored.
%   filename: Name of files to load (name of .xtekct file without the
%             extension).
%   experiment_name: Final part of the name of the reconstructed volume. 
%   voxels: Size of the reconstructed volume.
%    (optional parameters, necessary for partial reading)
%   slices: Number of slices to be read.
%   slice_choice: The first slice chosen to be read by the user.
%   full_read: Logical input.
%
% DEFAULT VALUES:
%   full_read: False or 0. However, if there is no info about the slices,
%              then the program automatically does a full read. 
%
% OUTPUT:
%   vol_soln: The variable name for the reconstructed volume.
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

vol_file = [pathname filename '_' experiment_name '.vol'];
% check whether a file with this name actually exists. Otherwise, output error.
if ~exist(vol_file,'file')
    errNoFile = MException('ResultChk:NoFile', ...
        'Error: No files with this name in the directory. Check and point to the correct directory.');
    throw(errNoFile);
end

%% Default values:
% If no info about slices, then set up to just read the full volume.
if nargin<5 
    full_read = 1;
elseif nargin<7 % but if there is slice info, then full read must be turned off...
    full_read = 0;
end

%% Reading volume:

if full_read % If no info about slices, then just read the full volume.
    vol_soln = read_float(vol_file);
    vol_soln = reshape(vol_soln,voxels);
else
    offset = voxels(1)*voxels(2)*(slice_choice-1)*4;
    no_slices = voxels(1)*voxels(2)*slices;
    vol_soln = read_float(vol_file,1,offset,no_slices);
    vol_soln = reshape(vol_soln,[voxels(1),voxels(2),slices]);
end

end


%%%%%% SUBROUTINE %%%%%%%%
% This function reads and returns the required volume by the user.
function block=read_float(filename,file_seek,offset,no_slices)

if nargin<2 % If no info is given, read the full volume.
    file_seek = 0;
    offset = 0;
    no_slices = 0;
end

fid=fopen(filename,'rb'); % Open file.

if file_seek==1;
    fseek(fid,((offset)),'bof'); % Get to the location where the first of no_slices is supposed to start.
    block=fread(fid,no_slices,'float','ieee-le'); % Read the next no_slices.
    frewind(fid); % Rewind back to the beginning of the file.
    if ftell(fid)~=0; disp('error with fseek'); end % If the location after rewind is not zero, there is a problem with fseek! 
else
    block=fread(fid,'float','ieee-le'); % Read the full volume.
end

fclose(fid); % Close file.

end
