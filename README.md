_your zenodo badge here_

# wang-etal_2022_jc

**Decipher the sensitivity of urban canopy air temperature to anthropogenic heat flux with a forcing-feedback framework**

Linying Wang\*<sup>1</sup>, Ting Sun<sup>2</sup>, Wenyu Zhou<sup>3</sup>, Maofeng Liu<sup>4</sup> and Dan Li<sup>1</sup>

<sup>1 </sup> Department of Earth and Environment, Boston University, Boston, Massachusetts

<sup>2 </sup> Institute for Risk and Disaster Reduction, University of College London, London, United Kingdom

<sup>3 </sup> Atmospheric Sciences & Global Change, Pacific Northwest National Laboratory, Richland, Washington

<sup>4 </sup> Rosenstiel School of Marine and Atmospheric, and Earth Science, University of Miami, Miami, Florida

\* corresponding author:  wangly@bu.edu

## Abstract
The sensitivity of urban canopy air temperature (*T<sub>a</sub>*) to anthropogenic heat flux (*Q<sub>AH</sub>*) is known to vary with space and time, but the key factors controlling such spatiotemporal variabilities remain elusive. In this study, we develop a forcing-feedback framework based on the energy budget of air within the urban canopy layer and apply it to diagnosing *∆T<sub>a</sub>/∆Q<sub>AH</sub>* simulated by the Community Land Model Urban (CLMU), where ∆ represents a change. Besides the direct effect of *Q<sub>AH</sub>* on *T<sub>a</sub>*, there are important feedbacks through changes in the surface temperature, the atmosphere-canopy air heat conductance (*c<sub>a</sub>*), and the surface-canopy air heat conductance. In summer, the positive and negative feedbacks nearly cancel each other and *∆T<sub>a</sub>/∆Q<sub>AH</sub>* is mostly controlled by the direct effect. In winter, however, *∆T<sub>a</sub>/∆Q<sub>AH</sub>* is enhanced due to the weakened negative feedback. The spatiotemporal variability of *∆T<sub>a</sub>/∆Q<sub>AH</sub>* and the nonlinear response of *∆T<sub>a</sub>* to *∆Q<sub>AH</sub>* are strongly related to the variability of *c<sub>a</sub>*, highlighting the importance of correctly parameterizing convective heat transfer in urban canopy models. 

## Journal reference

Wang, L., T. Sun, W. Zhou, M. Liu, & D. Li (2022). Decipher the sensitivity of urban canopy air temperature to anthropogenic heat flux with a forcing-feedback framework. Journal of Climate, in preparation.

## Code reference

https://github.com/IMMM-SFA/urban_clm5/tree/greenroof_version2.3.2

## Data reference

### Input data

https://svn-ccsm-inputdata.cgd.ucar.edu/trunk/inputdata/

### Output data

/global/cscratch1/sd/wangly/archive/urban_I2000Clm50SpGs_CONUS_NLDAS2_CTL
/global/cscratch1/sd/wangly/archive/urban_I2000Clm50SpGs_CONUS_NLDAS2_AH1
/global/cscratch1/sd/wangly/archive/urban_I2000Clm50SpGs_CONUS_NLDAS2_AH2
/global/cscratch1/sd/wangly/archive/urban_I2000Clm50SpGs_CONUS_NLDAS2_AH3

## Contributing modeling software
| Model | Version | Repository Link | DOI |
|-------|---------|-----------------|-----|
| CESM2 | release-cesm2.0.1 | https://github.com/ESCOMP/CESM/releases/tag/release-cesm2.0.1 | 10.1029/2019MS001916 |

## Reproduce my experiment

1. Install the software components required to conduct the experiement from [Contributing modeling software](#contributing-modeling-software). The detailed download instructions are also available online https://www.cesm.ucar.edu/models/cesm2/release_download.html.
2. Download and install the supporting input data required to conduct the experiement from [Input data](#input-data)
3. Run the following scripts in the `workflow` directory to re-create this experiment:

| Script Name | Description | How to Run |
| --- | --- | --- |
| `urban_I2000Clm50SpGs_CONUS_NLDAS2_spinup.sh` | Script to run the first part of my experiment (spinup) | `./urban_I2000Clm50SpGs_CONUS_NLDAS2_spinup.sh` |
| `urban_I2000Clm50SpGs_CONUS_NLDAS2_AH.sh` | Script to run the last part of my experiment (CTL, AH1, AH2, AH3) | `./urban_I2000Clm50SpGs_CONUS_NLDAS2_AH.sh` |

4. Download the output data from my experiment [Output data](#output-data)
5. Run the following scripts in the `workflow` directory for post-processing my outputs

| Script Name | Description | How to Run |
| --- | --- | --- |
| `post_process.f90` | Script for post-processing CLMU outputs | `ifort -g -CB -fpe0 -traceback post_process.f90 -L/opt/cray/pe/netcdf/4.6.3.2/intel/19.0/lib -lnetcdff -lnetcdf -I/opt/cray/pe/netcdf/4.6.3.2/intel/19.0/include -o a.out`  `./a.out` |

## Reproduce my figures
Use the scripts found in the `figures` directory to reproduce the figures used in this publication.

| Script Name | Description | How to Run |
| --- | --- | --- |
| `figure_name.ncl` | Script to generate my figures | `ncl figure_name.ncl` |
