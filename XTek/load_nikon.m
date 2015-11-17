function [data, geom] = load_nikon(pathname, filename, geom_type, slice)
%LOAD_NIKON
% Function loads the Nikon XTek data and the corresponding cone beam
% machine geometry.
%
% INPUT:
%   pathname: Name of path where the files are stored.
%   filename: Name of files to load (name of .xtekct file without the
%             extension).
%
% OUTPUT:
%   data: Returned Nikon XTek data in single format.
%   geom: Returned geometry structure array.
%
% Copyright (c) 2015 Sophia Bethany Coban
% Code is available via the SophiaBeads Datasets project.
% University of Manchester.

%% Quick error checking:

%pathname has to point to a folder:
if ~strcmp(pathname(end),'/')
    pathname = [pathname '/'];
    fprintf('WARNING: The input string pathname has to point to a folder. String has now been modified.\n');
end

%% Reading the .xtekct file:

fid = fopen([pathname filename '.xtekct']);  % Open the .xtekct file.

% Read parameters into cell array of strings:
params = textscan(fid, '%s %s', 'Delimiter', '=', 'HeaderLines', 1, 'CommentStyle', '[');

fclose(fid); % closing the file.

%% Extract relevant information from the .xtekct file:

ind = strcmp('SrcToObject', params{1});
SrcToObject = str2double(params{2}(ind));

ind = strcmp('SrcToDetector', params{1});
SrcToDetector = str2double(params{2}(ind));

ind = strcmp('DetectorPixelsX', params{1});
DetectorPixelsX = str2double(params{2}(ind));

ind = strcmp('DetectorPixelsY', params{1});
DetectorPixelsY = str2double(params{2}(ind));

ind = strcmp('DetectorPixelSizeX', params{1});
DetectorPixelSizeX = str2double(params{2}(ind));

ind = strcmp('DetectorPixelSizeY', params{1});
DetectorPixelSizeY = str2double(params{2}(ind));

ind = strcmp('Projections', params{1});
nProjections = str2double(params{2}(ind));

ind = strcmp('VoxelSizeX', params{1});
VoxelSize = str2double(params{2}(ind));

%% Load the projection data:

if nargin<4 % Default slice is the center slice!
    slice = DetectorPixelsY/2;
end

if strcmp(geom_type,'2D')
    [data,geom]=data_geom_2D(pathname,filename,DetectorPixelsX,DetectorPixelsY,DetectorPixelSizeY,nProjections,slice);
elseif strcmp(geom_type,'3D')
    [data,geom]=data_geom_3D(pathname,filename,DetectorPixelsX,DetectorPixelsY,DetectorPixelSizeY,nProjections);
else
    disp('Warning: Unrecognised geom_type. Consider only 2D or 3D');
end

% Final touches.
data = single(data); % Convert to single precision
data = data/65535; % this is the max value for 16bit integer
data = -log(data);

%% Set up the Cone Beam geometry:

geom.geom_type = geom_type; % Useful for error checking later...

% write source and detector coordinate values into geom structure array
geom.source.x = -SrcToObject; % Object is at the origin.
geom.source.y = 0;
geom.source.z = 0;

geom.dets.x = SrcToDetector-SrcToObject; % Distance between object to detector.
geom.dets.y = transpose(DetectorPixelSizeX*((-(DetectorPixelsX-1)/2):((DetectorPixelsX-1)/2)));
geom.dets.ny = DetectorPixelsX;

geom.d_sd = SrcToDetector; % Distance between source to detector.

% Load in the angle information
if exist([pathname '_ctdata.txt'],'file')
    temp = importdata([pathname '_ctdata.txt'], '\t', 3); % CONTINUOUS SCAN
    angles = temp.data(:,2);
    flip = false;
elseif exist([pathname filename '.ang'],'file')
    temp = importdata([pathname filename '.ang'], '\t', 1); % STOP/START SCAN
    angles = temp.data(:,1);
    flip = true;
end

geom.angles = (angles(1:nProjections)-90)*pi/180; % Convert angles to radians.
clear temp angles

% If the angles are decreasing, flip upside down.
if flip
    geom.angles = geom.angles(end:-1:1);
end

% Default values for the voxel space (these may change later.)
geom.voxel_size = VoxelSize*[1 1 1];
geom.image_offset = [0 0 0];

end


%% Subfunctions for 2D and 3D geometry setup and data loading.

function [data,geom]=data_geom_2D(pathname,filename,DetectorPixelsX,DetectorPixelsY,DetectorPixelSizeY,nProjections,slice)


geom.dets.z = 0.0;
geom.dets.nz = 1;

% Indicate where we are.
h = waitbar(0,'Loading projections...');
data = uint16(zeros(DetectorPixelsX, nProjections));
for i = 1:nProjections
    tmp_data = imread([pathname filename '_' dec2base(i,10,4) '.tif'])';
    data(:,i) = tmp_data(:,slice);
    waitbar(i/nProjections,h,['Loading projection ' num2str(i)]);
end
delete(h);

end

function [data,geom]=data_geom_3D(pathname,filename,DetectorPixelsX,DetectorPixelsY,DetectorPixelSizeY,nProjections)

geom.dets.z = transpose(DetectorPixelSizeY*((-(DetectorPixelsY-1)/2):((DetectorPixelsY-1)/2)));
geom.dets.nz = DetectorPixelsY;

% Indicate where we are.
h = waitbar(0,'Loading projections...');
data = uint16(zeros(DetectorPixelsX, DetectorPixelsY, nProjections));
for i = 1:nProjections
    data(:,:,i) = imread([pathname filename '_' dec2base(i,10,4) '.tif'])';
    waitbar(i/nProjections,h,['Loading projection ' num2str(i)]);
end
delete(h);

% Image pixels go down, whereas our z voxel ordering goes up, so flip.
data = data(:,end:-1:1,:);
end
