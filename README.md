# sophiabeads-datasets
This repository contains the code released for the SophiaBeads Datasets project. 

**Version:** V1.0

**DOI:** Zenodo Upload



### Introduction
Thank you for taking an interest in this project. The codes in this repository are released as part of the SophiaBeads Datasets Project, and tailored to be used to process and/or reconstruct the SophiaBeads Datasets. 


#### Purpose of the Project and the Code
SophiaBeads Datasets are acquired specifically for testing and comparing reconstruction methods for x-ray computed tomography. Our main objective is to provide a framework where reconstruction methods can be implemented and tested with the use of these datasets, where we know what the answer should be. You can find more information on the purpose of these datasets via _this paper_.

The datasets are collected using the _Nikon Custom Bay_ X-ray CT machine. The machine employs a cone-beam geometry and requires specific geometrical setup before the datasets can be used. The sophiabeads-datasets code _allows_ the user to interpret and use these datasets in their work. The codes in that sense are essential to use the SophiaBeads Datasets.

#### Downloading
Download the GitHub repository as a [tar.gz](https://codeload.github.com/Sophilyplum/sophiabeads-datasets/legacy.tar.gz/master) or a [zip](https://codeload.github.com/Sophilyplum/sophiabeads-datasets/legacy.zip/master) file at the top of this page.

Visit the [Zenodo SophiaBeads Datasets](https://zenodo.org/record/16474) page to access and download the datasets. 

#### Repository Contents
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

#### Documentation
A detailed documentation and tutorials about the codes can be found in _this report_.


#### Want to Contribute?
We are not open to external contributions. However, if you would still like to contribute with an idea or improved code, please get in touch and we will update the project with the appropriate attribution to you.

#### Contact Us
We do not offer user support for this code. However, we welcome any suggestions for improvements or ideas. 

To get in touch please visit [the contributor's website](http://www.maths.manchester.ac.uk/~scoban/contact.html) and fill in the contact form.

#### Important Notes
Please note that if you are using the SophiaBeads datasets and the project codes, you _must_ refer to both of these separately. 
* To cite the datasets, please export the relevant citation style on the right hand size of the Zenodo page.
* To cite the GitHub code, please _update with link_.
 
#### References
###### SophiaBeads Datasets

###### SophiaBeads Datasets Project Code

#### Licenses
The codes in sophiabeads-datasets are licensed under GPL v2 and MIT. Please read the documents LICENSE and LICENSE2 to learn more about using this code (you may also visit [choosealicense.com](http://choosealicense.com/) for comparisons).

##### Copyright (c) 2015 Sophia Bethany Coban
##### University of Manchester

