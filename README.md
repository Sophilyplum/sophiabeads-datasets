# sophiabeads-datasets
This repository contains the codes released for the SophiaBeads Datasets project.

**Release:** v2.0

**Initial Release Date:** 01-APR-2015

**Second Release Date:** 17-NOV-2015

[![DOI](https://zenodo.org/badge/doi/10.5281/zenodo.16539.svg)](http://dx.doi.org/10.5281/zenodo.16539)



# Introduction
Thank you for taking an interest in this project. The codes in this repository are released as part of the SophiaBeads Datasets Project, and tailored to be used to process and/or reconstruct the SophiaBeads Datasets.

### Purpose
SophiaBeads Datasets are acquired _specifically_ for testing and comparing reconstruction methods used for computed tomography problems. Our main objective is to provide a framework where reconstruction methods can be implemented and tested with the use of these datasets, where _we know what the reconstructed image is_. However, we first need to interpret the projection data and set up the correct scan geometry. To be able to do that, we have to use the SophiaBeads Datasets project codes. So these codes are **essential** in order to work with SophiaBeads Datasets.


The release contains scripts for loading the datasets, pre-reconstruction steps, and a reconstruction algorithm (cgls_XTek.m) as a template.


You can find more information on the purpose and application of these datasets in _this paper_.


# Downloading
Download the GitHub repository as a [tar.gz](https://codeload.github.com/Sophilyplum/sophiabeads-datasets/legacy.tar.gz/master) or a [zip](https://codeload.github.com/Sophilyplum/sophiabeads-datasets/legacy.zip/master) file at the top of this page. You may also access the codes on the [Zenodo release page](https://zenodo.org/record/16539).

Visit the Zenodo release page for the [SophiaBeads Datasets](https://zenodo.org/record/16474) to access and download the datasets (as zip files).

### Repository Contents
  * XTek/
    - CBproject.m
    - CBbackproject.m
    - load_nikon.m
  * c/
    - CBproject_c.c
    - CBbackproject_c.c
    - project_singledata.c
    - backproject_singledata.c
    - jacobs_rays.h
  * mex/
    - CBbackproject_c.mexa64
    - CBbackproject_c.mexmaci64
    - CBbackproject_c.mexw64
    - CBproject_c.mexa64
    - CBproject_c.mexmaci64
    - CBproject_c.mexw64
  * tools/
    - centre_geom.m
    - find_centre.m
    - read_vol.m
    - scrollView.m
    - write_tiff.m
    - write_vol.m
  - sophiaBeads.m
  - setup.m
  - pre_recon.m
  - cutDown_data.m
  - cgls_XTek.m


*NOTE*: Individual documentation can be obtained by running the command *help _scriptname_* in the MATLAB command window.

### Documentation
We strongly recommend the user to read the detailed documentation and tutorials about running the codes, which can be found in [this report](http://eprints.ma.man.ac.uk/2290/).

### Want to Contribute?
We are not open to external contributions. However, if you would still like to contribute with an idea or improved code, please get in touch and we will consider an update to the project (with the appropriate attribution to you).


## Contact Us
We do not offer user support for the project codes. However, we welcome any suggestions for improvements or ideas.

To get in touch please visit [the contributor's webpage](http://www.maths.manchester.ac.uk/~scoban) and fill in [the contact form](http://www.maths.manchester.ac.uk/~scoban/contact.html).

## Important Notes
1. Please note that if you are using the SophiaBeads Datasets and the project codes, you _must_ refer to both of these separately.
    - To cite the datasets, please export the relevant citation record on the right hand size of the Zenodo page.
    - To cite the GitHub code, visit the [Zenodo page for the project codes](https://zenodo.org/record/16539) and export the relevant citation record on the right hand side.

2. The MEX files for all platforms are included in the release, as well the source codes (written in C). This is done so the user is able to build and test own projectors and back projectors. We include an additional script (setup.m) for users to work with _as a template_. However, this does not guarantee that the script will work in any operating system (originally written for Linux; may work on Mac OSX depending on the version of Xcode; not tested in Windows).

3. Release V1.0 codes are tested with the following versions of MATLAB, installed on these operating systems:
    - **Scientific Linux 6**, **Ubuntu 12.04** and **14.04**: MATLAB R2010a, R2013a, 2014b.
    - **Mac OSX 10.9** (Mavericks) and **10.10** (Yosemite): MATLAB R2009b, R2013a, R2014b.
    - **Windows 7** and **8.1**: MATLAB R2012b, R2013a, R2014a, R2014b.

## References
**SophiaBeads Datasets**: [![DOI](https://zenodo.org/badge/doi/10.5281/zenodo.16474.svg)](http://dx.doi.org/10.5281/zenodo.16474)

**SophiaBeads Datasets Project Codes**: [![DOI](https://zenodo.org/badge/doi/10.5281/zenodo.16539.svg)](http://dx.doi.org/10.5281/zenodo.16539)

**Documentation**: [SophiaBeads Datasets Project Documentation and Tutorials](http://eprints.ma.man.ac.uk/2290/)


## Licenses
The codes in sophiabeads-datasets are distributed under the licenses GPL v2 and MIT. Please read the documents LICENSE and LICENSE2 to learn more about using these codes. You may also find it useful to visit [choosealicense.com](http://choosealicense.com/) and learn about these licenses.


#### Copyright (c) 2015 Sophia Bethany Coban
#### University of Manchester
