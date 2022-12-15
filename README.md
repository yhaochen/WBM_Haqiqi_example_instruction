# Purpose
This repository lists a step-by-step instruction on how to run the WBM submodel performed in Haqiqi et al (2021). 

(Full citation of the paper: Haqiqi, I. et al. (2021) ‘Quantifying the impacts of compound extremes on agriculture’, Hydrology and Earth System Sciences, 25(2), pp. 551–564. Available at: https://doi.org/10.5194/hess-25-551-2021.)

# Intro to WBM
See the detailed information of WBM at: https://github.com/wsag/WBM

# Source Data
The required source data can be downloaded from the FTP server:

**ftp merrimack.sr.unh.edu**

**login: ftp**

**password:anything**

Users can first locate the directory to store the data (note: the data size is more than 1TB, make sure the computation system has available space), and then use the following "wget" command to download the data: 

`wget --ftp-user=ftp --ftp-pass=anything -r ftp://merrimack.sr.unh.edu/US_CDL_v3_data`

For users with access to the Penn State ROAR system and within the PCHES team , the data is pre-downloaded at: 

**/gpfs/group/kaf26/default/private/WBM_data/**

# Instructions to run the WBM

### 1. Download and install the WBM via container 
