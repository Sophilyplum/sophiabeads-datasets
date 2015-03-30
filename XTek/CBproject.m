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
% Written by W.Thompson, modified by S.B. Coban for the SophiaBeads Datasets project.
% University of Manchester, 2015.

b = CBproject_c(geom.voxels,geom.source.x,geom.source.y,geom.source.z,geom.dets.x,geom.dets.y,geom.dets.z,geom.voxel_size,geom.image_offset,x,geom.angles);