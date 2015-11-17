function geom = centre_geom(data, geom, c_slice)
%CENTRE_GEOM
% Function to calculate the centre of rotation for given Nikon XTek cone 
% beam geometry and data, and apply this to the geometry structure.
%
% INPUT:
%   data: Nikon XTek cone beam scan data.
%   geom: Geometry structure array.
%   c_slice: Index of centre slice. By default, this is the very centre of
%   2000 slices. 
%
% OUTPUT:
%   geom: Updated geometry structure array.
%   
% Copyright (c) 2015 Sophia Bethany Coban, William Michael Thompson and Nicola Wadeson
% Code is available via the SophiaBeads Datasets project.
% University of Manchester.

% Check to see if 2D data, if not then work with the central slice
if geom.dets.nz ~= 1
    if nargin<3
        [data, tmp_geom] = convert2D(data, geom);
    else
        [data, tmp_geom] = convert2D(data, geom, c_slice);
    end
else
    tmp_geom = geom;
end

% Find centre of rotation...
centre = find_centre(reshape(data, geom.dets.ny, length(geom.angles)), tmp_geom);

% Apply the corrected centre of rotation to the geometry...
geom.source.y = geom.source.y + centre;
geom.dets.y = geom.dets.y + centre;

end

function [b, geom, c_slice] = convert2D(data, geom, c_slice)
%Function to temporarily convert 3D XTek data into 2D, using a central
% slice. The user is able to pick one of their own. The centre slice is the
% very centre of 2000 slices by default.
% 
% This is a subfunction to CENTRE_GEOM.
%
% Written by W.Thompson, modified by S.B. Coban for the SophiaBeads Datasets project.
% University of Manchester, 2015.

if nargin<3
    c_slice = floor(geom.dets.nz/2 + 1);
end

b = squeeze(data(:,c_slice,:));

geom.dets.z = geom.dets.z(c_slice);

geom.dets.nz = length(c_slice);

end
