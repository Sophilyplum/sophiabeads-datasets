% A short script to build the mex files for forward and back projectors.
% Saves the output in the mex/ folder.
%
% Copyright (c) 2015 Sophia Bethany Coban
% Code is available via the SophiaBeads Datasets project.
% University of Manchester.

mkdir('mex'); disp('Created the folder mex/...');

addpath c/ mex/; 

mex c/CBbackproject_c.c c/backproject_singledata.c -largeArrayDims CFLAGS="\$CFLAGS -fopenmp" LDFLAGS="\$LDFLAGS -fopenmp" -output mex/CBbackproject_c
mex c/CBproject_c.c c/project_singledata.c -largeArrayDims CFLAGS="\$CFLAGS -fopenmp" LDFLAGS="\$LDFLAGS -fopenmp" -output mex/CBproject_c

disp('Mex files are created and saved successfully in folder mex/.');
rmpath c/;