function x = CBbackproject(b, geom)
%CBBACKPROJECT
% This function performs cone beam backprojection for reconstruction
% algorithms. This acts as an interface for the C routine. 
%
% INPUT:
%   b: Sinogram (Nikon XTek dataset). 
%   geom: Geometry structure array.
% 
% OUTPUT:
%   x: Image (volume data). 
%
% Copyright (c) Sophia Bethany Coban and William Michael Thompson
% Code is available via the SophiaBeads Datasets project.
% University of Manchester, 2015.

x = CBbackproject_c(geom.voxels,geom.source.x,geom.source.y,geom.source.z,geom.dets.x,geom.dets.y,geom.dets.z,geom.voxel_size,geom.image_offset,b,geom.angles);
