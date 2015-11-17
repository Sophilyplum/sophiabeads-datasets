/* 
jacobs_rays HEADER FILE
Written by David Szotten, modified by Sophia Bethany Coban for the SophiaBeads Datasets project. University of Manchester, 2015.
*/
 
/*
References:
 David Szotten, Limited Data Problems in X-ray and Polarized Light Tomography. PhD Thesis, School of Mathematics, University of Manchester. 2011.
*/

/* 
Copyright (c) 2015 Sophia Bethany Coban and David Szotten
Code is available via the SophiaBeads Datasets project.
University of Manchester.
*/

#ifndef _JACOBSRAYS_HEADER_
#define _JACOBSRAYS_HEADER_


/* ************** OPTIONS ************** */

#define PRECISION 0.00000001 /* for calculating rays intersecting voxels*/

/* ************************************* */

#include <mex.h>
#include <math.h>
#include <matrix.h>
#include <stdlib.h>
#include <stdio.h>


#define jacobs_PI 3.14159265358979

struct jacobs_options {
    int im_size_default, b_default, d_default;
    int im_size_x, im_size_y, im_size_z;
    double b_x, b_y, b_z, d_x, d_y, d_z;
};


#endif
