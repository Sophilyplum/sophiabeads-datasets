/* 
 Function to perform cone beam forward projection of Nikon XTek Custom Bay data in a single step.
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

#include "jacobs_rays.h"

/* Initialize. */
int equal_to_precision(double x, double y, double precision);
double alpha_fn(int n, double p1, double p2, double b, double d);
double p(double alpha, double p1, double p2);
double phi(double alpha, double p1, double p2, double b, double d);

double min_dbl(double a, double b) { return a < b ? a : b; };
double max_dbl(double a, double b) { return a > b ? a : b; };

double min3_dbl(double a, double b, double c) { return a < b ? min_dbl(a,c) : min_dbl(b,c); };
double max3_dbl(double a, double b, double c) { return a > b ? max_dbl(a,c) : max_dbl(b,c); };

double ceil_j( double arg ) { return arg == (int)arg ? arg+1 : ceil( arg ); };
double floor_j( double arg ) { return floor( arg ); };


void project_singledata(int im_size, double *start, double *end, float *ray_data, float *vol_data, struct jacobs_options *options)
{
	/* Initialize. */
    int N_x, N_y, N_z, N_p, im_size_x, im_size_y, im_size_z;
    double b_x, b_y, b_z, d_x, d_y, d_z, d_conv;
    double p1_x, p1_y, p1_z, p2_x, p2_y, p2_z;
    
    int x_defined, y_defined, z_defined;
    int i,j,k;
    
    double alpha_x_min, alpha_y_min, alpha_z_min, alpha_x_max, alpha_y_max, 
	alpha_z_max, alpha_min, alpha_max, alpha_x, alpha_y, alpha_z, alpha_c;
    double alpha_x_u, alpha_y_u, alpha_z_u;
    double l_ij;
    int i_min, j_min, k_min, i_max, j_max, k_max, n_count, i_u, j_u, k_u;
    
    int ray_index;
	
	/* Copy information. */
    p1_x = start[0];
    p1_y = start[1];
    p1_z = start[2];
    p2_x = end[0];
    p2_y = end[1];
    p2_z = end[2];

    im_size_x = options->im_size_x;
    im_size_y = options->im_size_y;
    im_size_z = options->im_size_z;

	N_x=im_size_x+1;
	N_y=im_size_y+1;
	N_z=im_size_z+1;

	/* d: voxel size */
    d_x = options->d_x;
    d_y = options->d_y;
    d_z = options->d_z;

	/* b: grid offset from origin */
    b_x = options->b_x;
    b_y = options->b_y;
    b_z = options->b_z;
    
    /* use total lengh=alpha_max-alpha_min instead, to get an average, not sum. */ 
    /* moving back to original d_conv */
    d_conv=sqrt( (p1_x-p2_x)*(p1_x-p2_x) + (p1_y-p2_y)*(p1_y-p2_y) + (p1_z-p2_z)*(p1_z-p2_z));

	/* x, y or z are defined if planes are not equal! */
    x_defined =  !(equal_to_precision(p1_x,p2_x,PRECISION));
    y_defined =  !(equal_to_precision(p1_y,p2_y,PRECISION));
    z_defined =  !(equal_to_precision(p1_z,p2_z,PRECISION));
	
	/* Jacob's ray tracing algorithm... */
    if( !x_defined && !y_defined && !z_defined)
	return;

    if (x_defined) {
	alpha_x_min=min_dbl(alpha_fn(0, p1_x, p2_x, b_x, d_x), alpha_fn(N_x-1, p1_x, p2_x, b_x, d_x));
	alpha_x_max=max_dbl(alpha_fn(0, p1_x, p2_x, b_x, d_x), alpha_fn(N_x-1, p1_x, p2_x, b_x, d_x));
    }
    else {
	alpha_x_min=-2;
	alpha_x_max=2;
	i=(int) floor_j( phi(0.0, p1_x, p2_x, b_x, d_x));
	if ( i < 0 || i >= im_size_x)
	    return;
	alpha_x=2;
	i_min = 1;
	i_max = 0;
    }

    if(y_defined) {
	alpha_y_min=min_dbl(alpha_fn(0, p1_y, p2_y, b_y, d_y), alpha_fn(N_y-1, p1_y, p2_y, b_y, d_y));
	alpha_y_max=max_dbl(alpha_fn(0, p1_y, p2_y, b_y, d_y), alpha_fn(N_y-1, p1_y, p2_y, b_y, d_y));
    }
    else {
	alpha_y_min=-2;
	alpha_y_max=2;
	j=(int) floor_j( phi(0.0, p1_y, p2_y, b_y, d_y));
	if ( j < 0 || j >= im_size_y)
	    return;
	alpha_y=2;
	j_min = 1;
	j_max = 0;
    }

    		
    if(z_defined) {
	alpha_z_min=min_dbl(alpha_fn(0, p1_z, p2_z, b_z, d_z), alpha_fn(N_z-1, p1_z, p2_z, b_z, d_z));
	alpha_z_max=max_dbl(alpha_fn(0, p1_z, p2_z, b_z, d_z), alpha_fn(N_z-1, p1_z, p2_z, b_z, d_z));
    }
    else {
	alpha_z_min=-2;
	alpha_z_max=2;
	k=(int) floor_j( phi(0.0, p1_z, p2_z, b_z, d_z));
	if ( k < 0 || k >= im_size_z)
	    return;
	alpha_z=2;
	k_min = 1;
	k_max = 0;
    }
		
    alpha_min=max_dbl(0.0, max3_dbl(alpha_x_min, alpha_y_min, alpha_z_min));
    alpha_max=min_dbl(1.0, min3_dbl(alpha_x_max, alpha_y_max, alpha_z_max));

    /* If ray intersects voxel grid */
    if (alpha_min < alpha_max) {

	if (x_defined && p1_x < p2_x) {
	    if (equal_to_precision(alpha_min,alpha_x_min,PRECISION)==1)
		i_min=1;
	    else
		i_min = (int) ceil_j(phi(alpha_min, p1_x, p2_x, b_x, d_x));

	    if (equal_to_precision(alpha_max,alpha_x_max,PRECISION)==1)
		i_max = N_x - 1;
	    else
		i_max = (int) floor_j( phi(alpha_max, p1_x, p2_x, b_x, d_x));

	    alpha_x=alpha_fn(i_min, p1_x, p2_x, b_x, d_x);
	}

	else if (x_defined) {
	    if (equal_to_precision(alpha_min,alpha_x_min,PRECISION)==1)
		i_max=N_x-2;
	    else
		i_max = (int) floor_j(phi(alpha_min, p1_x, p2_x, b_x, d_x));

	    if (equal_to_precision(alpha_max,alpha_x_max,PRECISION)==1)
		i_min = 0;
	    else
		i_min = (int) ceil_j( phi(alpha_max, p1_x, p2_x, b_x, d_x));

	    alpha_x=alpha_fn(i_max, p1_x, p2_x, b_x, d_x);
	}


	if (y_defined && p1_y < p2_y) {
	    if (equal_to_precision(alpha_min,alpha_y_min,PRECISION)==1)
		j_min=1;
	    else
		j_min = (int) ceil_j(phi(alpha_min, p1_y, p2_y, b_y, d_y));


	    if (equal_to_precision(alpha_max, alpha_y_max,PRECISION)==1)
		j_max = N_y - 1;
	    else
		j_max = (int) floor_j( phi(alpha_max, p1_y, p2_y, b_y, d_y));

	    alpha_y=alpha_fn(j_min, p1_y, p2_y, b_y, d_y);
	}

	else if (y_defined) {

	    if (equal_to_precision(alpha_min,alpha_y_min,PRECISION)==1)
		j_max=N_y-2;
	    else
		j_max = (int) floor_j(phi(alpha_min, p1_y, p2_y, b_y, d_y));


	    if (equal_to_precision(alpha_max, alpha_y_max, PRECISION)==1)
		j_min = 0;
	    else
		j_min = (int) ceil_j( phi(alpha_max, p1_y, p2_y, b_y, d_y));

	    alpha_y=alpha_fn(j_max, p1_y, p2_y, b_y, d_y);
	}



	if (z_defined && p1_z < p2_z) {
	    if (equal_to_precision(alpha_min,alpha_z_min,PRECISION)==1)
		k_min=1;
	    else
		k_min = (int) ceil_j(phi(alpha_min, p1_z, p2_z, b_z, d_z));


	    if (equal_to_precision(alpha_max, alpha_z_max,PRECISION)==1)
		k_max = N_z - 1;
	    else
		k_max = (int) floor_j( phi(alpha_max, p1_z, p2_z, b_z, d_z));

	    alpha_z=alpha_fn(k_min, p1_z, p2_z, b_z, d_z);
	}

	else if (z_defined) {

	    if (equal_to_precision(alpha_min,alpha_z_min,PRECISION)==1)
		k_max=N_z-2;
	    else
		k_max = (int) floor_j(phi(alpha_min, p1_z, p2_z, b_z, d_z));


	    if (equal_to_precision(alpha_max, alpha_z_max, PRECISION)==1)
		k_min = 0;
	    else
		k_min = (int) ceil_j( phi(alpha_max, p1_z, p2_z, b_z, d_z));

	    alpha_z=alpha_fn(k_max, p1_z, p2_z, b_z, d_z);
	}


	N_p=(i_max - i_min +1) + (j_max - j_min + 1) + (k_max - k_min + 1);

	if (x_defined) {
	    i=(int) floor_j( phi( (min3_dbl(alpha_x, alpha_y, alpha_z) + alpha_min)/2, p1_x, p2_x, b_x, d_x) );
	alpha_x_u = d_x/fabs(p2_x-p1_x);
	}

	if (y_defined) {
	    j=(int) floor_j( phi( (min3_dbl(alpha_x, alpha_y, alpha_z) + alpha_min)/2, p1_y, p2_y, b_y, d_y) );
	alpha_y_u = d_y/fabs(p2_y-p1_y);
	}
	if (z_defined) {
	    k=(int) floor_j( phi( (min3_dbl(alpha_x, alpha_y, alpha_z) + alpha_min)/2, p1_z, p2_z, b_z, d_z) );
	alpha_z_u = d_z/fabs(p2_z-p1_z);
	}

	if (p1_x < p2_x)
	    i_u=1;
	else
	    i_u=-1;

	if (p1_y < p2_y)
	    j_u=1;
	else
	    j_u=-1;

	if (p1_z < p2_z)
	    k_u=1;
	else
	    k_u=-1;


	alpha_c=alpha_min;

	for (n_count=1; n_count<N_p+1;n_count++) {

	    /* x smallest */
	    if (x_defined && alpha_x <= alpha_y && alpha_x <= alpha_z) {
		/* Ray intersects pixel(i,j) with length l_ij */

		ray_index = k*im_size_y*im_size_x + j*im_size_x + i;
        (*ray_data) += ((float) ((alpha_x-alpha_c)*d_conv)) * vol_data[ray_index];

		if( y_defined && alpha_x == alpha_y) {
		    j += j_u;
		    n_count++;
		    alpha_y += alpha_y_u;
		}

		if( z_defined && alpha_x == alpha_z) {
		    k += k_u;
		    n_count++;
		    alpha_z += alpha_z_u;
		}

		i += i_u;
		alpha_c=alpha_x;
		alpha_x += alpha_x_u;
	    }

	    /* y smallest */
	    else if (y_defined && alpha_y <= alpha_z) {
		/* Ray intersects pixel(i,j) with length l_ij */

		ray_index = k*im_size_y*im_size_x + j*im_size_x + i;
		(*ray_data) += ((float) ((alpha_y-alpha_c)*d_conv)) * vol_data[ray_index];

		if( z_defined && alpha_y == alpha_z) {
		    k += k_u;
		    n_count++;
		    alpha_z += alpha_z_u;
		}

		j=j+j_u;
		alpha_c=alpha_y;
		alpha_y += alpha_y_u;
	    }

	    /* z smallest */
	    else if (z_defined) {
		/* Ray intersects pixel(i,j) with length l_ij */

		ray_index = k*im_size_y*im_size_x + j*im_size_x + i;
		(*ray_data) += ((float) ((alpha_z-alpha_c)*d_conv)) * vol_data[ray_index];

		k += k_u;
		alpha_c=alpha_z;
		alpha_z += alpha_z_u;
	    }

	    /* Have we looped too far? */
	    if( i < 0 || j < 0 || k < 0 || i >= im_size_x || j >= im_size_y || k >= im_size_z)
		/* Artificially end loop */
		N_p = n_count - 1;

	} /* end of for loop though N_p */
                
	/* In case we're ending inside grid, finish off last voxel */
	if( (alpha_max - alpha_c) > PRECISION) {
	    /* This is the last step so don't need to worry about incrementing i or j */
	    l_ij=(alpha_max-alpha_c)*d_conv;
	    
	    ray_index = k*im_size_y*im_size_x + j*im_size_y + i;
	    (*ray_data) += ((float) l_ij) * vol_data[ray_index];
	}
	
    } /* of alpha_min < alpha_max */
    return;
}


double alpha_fn(int n, double p1, double p2, double b, double d)
{
    return ( (b+n*d) - p1)/(p2-p1);
}

double phi(double alpha, double p1, double p2, double b, double d)
{
    return ( p(alpha, p1, p2)-b)/d;
}

double p(double alpha, double p1, double p2)
{
    return p1+alpha*(p2-p1);
}

int equal_to_precision(double x, double y, double prec)
{
    return fabs(x-y) < prec;
}

