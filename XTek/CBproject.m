function b = CBproject(x, geom)
%CBPROJECT
% This function performs cone beam forward projection for reconstruction
% algorithms. This acts as an interface for the C routine. 
%
% INPUT:
%   x: Image (volume data).
%   geom: Geometry structure array.
% 
% OUTPUT:
%   b: Sinogram (Nikon XTek dataset). 
%
% Copyright (c) 2015 Sophia Bethany Coban, William Michael Thompson and Nicola Wadeson
% Code is available via the SophiaBeads Datasets project.
% University of Manchester.

b = CBproject_c(geom.voxels,geom.source.x,geom.source.y,geom.source.z,geom.dets.x,geom.dets.y,geom.dets.z,geom.voxel_size,geom.image_offset,x,geom.angles);
