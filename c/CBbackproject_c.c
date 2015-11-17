/* 
 MEX Function to perform cone beam back projection of Nikon XTek Custom Bay data.
 Published as part of the SophiaBeads Datasets project. 
*/

/*
References:
 David Szotten, Limited Data Problems in X-ray and Polarized Light Tomography. PhD Thesis, School of Mathematics, University of Manchester. 2011.
 William Michael Thompson, Source firing patterns and reconstruction algorithms for a switched source, offset detector CT machine. PhD Thesis, School of Mathematics, University of Manchester. 2011.
 Nicola Wadeson, Aluminium foam data reconstruction using CGLS and TV Regularisation - 100 and 200 projection data. MIMS Preprint, School of Mathematics, University of Manchester. August 2012.
*/

/* 
Copyright (c) 2015 Sophia Bethany Coban, William Michael Thompson, Nicola Wadeson and David Szotten
Code is available via the SophiaBeads Datasets project.
University of Manchester.
*/

#include <mex.h>
#include <math.h>
#include <matrix.h>
#include <stdlib.h>
#include <string.h>
#include "jacobs_rays.h"
#include "omp.h"


void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
	/* Check number of arguments. */
	if(nrhs != 11)
    {
		mexWarnMsgTxt("11 inputs required. Aborting...");
		return;
    }
	else if(nlhs < 1)
    {
		mexWarnMsgTxt("At least one output required. Aborting...");
		return;
	}

	/* Initialize variables. */
	int i, curr_angle, im_size, n_rays_y, n_rays_z, curr_ray_y, curr_ray_z, n_angles, ray_offset;
	mwSize im_size_matlab[3];
	double *source_x, *source_y, *source_z, *det_x, *det_y, *det_z;
    double cos_curr_angle, sin_curr_angle;
	double start[3], end[3], *voxel_size, *grid_offset, *angles;
    float *ray_data, *vol_data;
    double *size_doubles;

	struct jacobs_options options;
	
	/* Reading variables. */
	size_doubles = mxGetPr(prhs[0]);
	for(i = 0; i < 3; i++)
    {
	    im_size_matlab[i] = (int) size_doubles[i];
    }

	/* Number of detector elements. */
    n_rays_y = mxGetM(prhs[5]);
    n_rays_z = mxGetM(prhs[6]);
    
    /* Source and detector locations. */
 	source_x = mxGetPr(prhs[1]); 
 	source_y = mxGetPr(prhs[2]); 
 	source_z = mxGetPr(prhs[3]); 
 	det_x = mxGetPr(prhs[4]); 
 	det_y = mxGetPr(prhs[5]); 
 	det_z = mxGetPr(prhs[6]); 

	/* Additional information. */
	voxel_size = mxGetPr(prhs[7]);
	grid_offset = mxGetPr(prhs[8]);
    
    ray_data = (float *) mxGetData(prhs[9]);
    
    angles = mxGetPr(prhs[10]);
    n_angles = mxGetM(prhs[10]);
    
    /* Check if dimensions work... */
    if (mxGetM(prhs[9]) != (n_rays_y * n_rays_z * n_angles))
    {
        mexWarnMsgTxt("Mismatched number of data points! Aborting.");
        return;
    }

	/* Set jacobs options.  */
	options.im_size_default = 0;
	options.im_size_x = im_size_matlab[0];
	options.im_size_y = im_size_matlab[1];
	options.im_size_z = im_size_matlab[2];

	options.b_default = 0;
	options.b_x = grid_offset[0];
	options.b_y = grid_offset[1];
	options.b_z = grid_offset[2];

	options.d_default = 0;
	options.d_x = voxel_size[0];
	options.d_y = voxel_size[1];
	options.d_z = voxel_size[2];

	/* Initialize output. */
	plhs[0] = mxCreateNumericMatrix(im_size_matlab[0]*im_size_matlab[1]*im_size_matlab[2], 1, mxSINGLE_CLASS, mxREAL);
	vol_data = (float *) mxGetData(plhs[0]);

	/* Parallelized... */
    #pragma omp parallel for shared(source_x, source_y, source_z, det_x, det_y, det_z, im_size, ray_data, vol_data, angles, options, n_angles, n_rays_y, n_rays_z) private(curr_angle, curr_ray_y, curr_ray_z, cos_curr_angle, sin_curr_angle, start, end, ray_offset) schedule(dynamic)
    for(curr_angle = 0; curr_angle < n_angles; curr_angle++)
    {
        /* Rotate source and detector positions by current angle. */
        cos_curr_angle = cos(angles[curr_angle]);
        sin_curr_angle = sin(angles[curr_angle]);
        
        start[0] = cos_curr_angle * (*source_x) - sin_curr_angle * (*source_y);
        start[1] = sin_curr_angle * (*source_x) + cos_curr_angle * (*source_y);
        start[2] = *source_z;
        
        ray_offset = curr_angle * n_rays_y * n_rays_z;
        
        /* Loop over y values on detector. */
        for(curr_ray_y = 0; curr_ray_y < n_rays_y; curr_ray_y++)
        {
            end[0] = cos_curr_angle * (*det_x) - sin_curr_angle * det_y[curr_ray_y];
            end[1] = sin_curr_angle * (*det_x) + cos_curr_angle * det_y[curr_ray_y];
            
            /* Loop over z values on detector. */
            for(curr_ray_z = 0; curr_ray_z < n_rays_z; curr_ray_z++)
            {
                end[2] = det_z[curr_ray_z];
				
				/* Perform back projection (in a single step). */
                backproject_singledata(im_size, start, end, &ray_data[ray_offset + curr_ray_z*n_rays_y + curr_ray_y], vol_data, &options);
            }
        }
    }
}

