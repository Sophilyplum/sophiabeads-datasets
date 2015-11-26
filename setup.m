% A short script to build the mex files for forward and back projectors.
% Saves the output in the mex/ folder.
%
%
% PLEASE NOTE that this script is intended to be a TEMPLATE and should be
% used if the user is interested in building/testing own projector and
% backprojector mex files.
% The script would only need to be run once, and will overwrite the existing
% projector and backprojector mex files. To avoid this, modify the name after
% -output option in lines 22 and 23.
% To run before a SophiaBeads Dataset, uncomment line 22 in sophiabeads.m.
%
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
