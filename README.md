README
================

This is the code used for data processing and statistical analyses in
Flaherty, R., et al. (2024). 
*A Diffusion Kurtosis MRI Signature of Subjective Cognitive Decline*. 
Presented at the Alzheimer's Association International Conference, 2024, Philadelphia, PA.

## Directions

Running this code requires the following dependencies:

- RStudio \>= 2023.09.1+494 with the following packages:
  - base
  - tidyverse
  - arsenal
  - ggpubr
- python == 3.7 with the following packages:
  - packaging
  - numpy
  - PyDesigner == 1.0.0
  - pybids
  - mrtrix3 == 3.0.4
  - pandas
  - dmri-amico == 2.0.1
  - nipype
- FreeSurfer == 7.4.1
- FSL == 6.0.6
  
It is highly recommended to conduct this analysis on an HPC. Scripts with .sh extensions are written for
Mate Desktop and can be run with either bash or zsh.

Run each numbered script in order. Unnumbered scripts are called by the
numbered scripts and do not need to be called manually. Wait until the
script finishes before starting the next numbered script.

Some subjects do not have fieldmap images available. These are processed using the scripts ending in "_nofmap".
Subject CC721434 has incorrect orientation labels on their fieldmap images. These are remedied by running "sub-CC721434_fmap_corr.py".

The original analysis was conducted on Red Hat Enterprise Linux Server
release 7.4.

## License
Shield: [![CC BY-SA
4.0](https://img.shields.io/badge/License-CC%20BY--SA%204.0-lightgrey.svg)](http://creativecommons.org/licenses/by-sa/4.0/)
This work is licensed under a [Creative Commons Attribution-ShareAlike
4.0 International
License](http://creativecommons.org/licenses/by-sa/4.0/).
[![CC BY-SA
4.0](https://licensebuttons.net/l/by-sa/4.0/88x31.png)](http://creativecommons.org/licenses/by-sa/4.0/)
