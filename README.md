# sophiabeads-datasets
This repository contains the code released for the SophiaBeads Datasets project. 

**Version:** V1.0

**DOI:** Zenodo Upload



### Introduction
Thank you for taking an interest in this project. The codes in this repository are released as part of the SophiaBeads Datasets Project, and tailored to be used to process and/or reconstruct the SophiaBeads Datasets. 


### Purpose
SophiaBeads Datasets are acquired _specifically_ for testing and comparing reconstruction methods used for computed tomography problems. Our main objective is to provide a framework where reconstruction methods can be implemented and tested with the use of these datasets, where _we know what the reconstructed image is_. However, to be able to reconstruct these datasets, we first have to know how to interpret the projection data and set up the correct scan geometry. To be able to do that, we have to use the SophiaBeads Datasets project codes -- these codes are **essential** in order to reconstruction SophiaBeads Datasets. 


You can find more information on the purpose and application of these datasets in _this paper_.

### Downloading
Download the GitHub repository as a [tar.gz](https://codeload.github.com/Sophilyplum/sophiabeads-datasets/legacy.tar.gz/master) or a [zip](https://codeload.github.com/Sophilyplum/sophiabeads-datasets/legacy.zip/master) file at the top of this page.

Visit the [Zenodo SophiaBeads Datasets](https://zenodo.org/record/16474) page to access and download the datasets (zip files). 

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
    - write_tiff.m
    - write_vol.m
  - sophiaBeads.m
  - setup.m
  - pre_recon.m
  - cutDown_data.m
  - cgls_XTek.m


*NOTE*: Individual help can be obtained by running the command 'help <scriptname>' in MATLAB command window.

### Documentation
We strongly recommend the user to read the detailed documentation and tutorials about running the codes, which can be found in _this report_.

### Want to Contribute?
We are not open to external contributions. However, if you would still like to contribute with an idea or improved code, please get in touch and we will consider an update to the project with the appropriate attribution to you.

### Contact Us
We do not offer user support for the project codes. However, we welcome any suggestions for improvements or ideas. 

To get in touch please visit [the contributor's website](http://www.maths.manchester.ac.uk/~scoban/contact.html) and fill in the contact form.

### Important Notes
  1. Please note that if you are using the SophiaBeads Datasets and the project codes, you _must_ refer to both of these separately. 
    - To cite the datasets, please export the relevant citation style on the right hand size of the Zenodo page.
    - To cite the GitHub code, please _update with link_.

  2. The MEX files for all platforms are included in the release, as well the sourcecodes (written in c). This is done so the user is able to build and test own projectors and backprojectors. We include an additional script (setup.m) for users to work with _as a template_. However, this does not guarantee that the script will work in any operating system (not tested in Windows).

  3. Version V1.0 codes are tested with the following versions of MATLAB, installed on major operating systems:
    - **Scintific Linux 6**, **Ubuntu 12.04** and **14.04**: MATLAB R2010a, R2013a, 2014b.
    - **Mac OSX 10.9** (Mavericks) and **10.10** (Yosemite): MATLAB R2009b, R2013a, R2014b.
    - **Windows 7** and **8.1**: MATLAB R2012b, R2013a, R2014a, R2014b. 
 
### References
**SophiaBeads Datasets** [![DOI](https://zenodo.org/badge/doi/10.5281/zenodo.16474.svg)](http://dx.doi.org/10.5281/zenodo.16474)

**SophiaBeads Datasets Project Codes** 

**Documentation** [SophiaBeads Datasets Reconstruction and Quantification Tutorials][mimslink] 


### Licenses
The codes in sophiabeads-datasets are licensed under GPL v2 and MIT. Please read the documents LICENSE and LICENSE2 to learn more about using this code. You may also find it useful to visit [choosealicense.com](http://choosealicense.com/) and learn about these licenses.


###### Copyright (c) 2015 Sophia Bethany Coban
###### University of Manchester

