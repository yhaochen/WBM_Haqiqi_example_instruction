# Purpose
This repository lists a step-by-step instruction on how to run the Water Balance Model (WBM) submodel performed in Haqiqi et al (2021). 

(Full citation of the paper: Haqiqi, I. et al. (2021) ‘Quantifying the impacts of compound extremes on agriculture’, Hydrology and Earth System Sciences, 25(2), pp. 551–564. Available at: https://doi.org/10.5194/hess-25-551-2021.)

# Intro to WBM
The introduction of WBM is not the focus of this repository. See the detailed information of WBM at: https://github.com/wsag/WBM

# Source Data
The required source data can be downloaded from the FTP server:

**ftp merrimack.sr.unh.edu**

**login: ftp**

**password:anything**

Users can first locate the folder to store the data (note: the data size is more than 1TB, make sure the computation system has available space), and then use the following "wget" command to download the data: 

`wget --ftp-user=ftp --ftp-pass=anything -r ftp://merrimack.sr.unh.edu/US_CDL_v3_data`

For users with access to the Penn State ROAR system and within the PCHES team , the data is pre-downloaded at: 

**/gpfs/group/kaf26/default/private/WBM_data/**

# Instructions to run the WBM

For convenience, before starting, create an empty folder where you want to install the WBM and corresponding files (this is different from the folder that stores the data). Locate to this folder.

### 1. Download and install the WBM 

Here we simply introduce the required steps and commands for downloading and installation. See more detailed information about the installation at: https://github.com/pches/WBM_localPSUguide/blob/main/WBM_howTo.md (credit to Matthew Lisk).


First download the WBM container and its readme file:

```
wget https://wbm.unh.edu/v1.0.0/wbm_opensource_v1.0.0.sif 
wget https://wbm.unh.edu/v1.0.0/wbm_opensource_v1.0.0_Readme.txt
```

Then download the WBM storage directory structure and its readme file:

```
wget https://wbm.unh.edu/v1.0.0/wbm_storage_v1.0.0.tar.gz
wget https://wbm.unh.edu/v1.0.0/wbm_storage_v1.0.0_Readme.txt
```

Then uncompress the storage directory file:

`tar -xvzf ./wbm_storage_v1.0.0.tar.gz`

After this step you should see a folder called `wbm_storage_v1.0.0`. Its structure and corresponding data inside it is contained in this repository.

### 2. Create a WBM container

A container is required to ensure the environment is the same when running WBM. To create a container, there are several options (again see details at https://github.com/pches/WBM_localPSUguide/blob/main/WBM_howTo.md). You may pick one from the two options (they are essentially the same).

Option 1: Creating a Singularity Instance
```
singularity instance start \
  -B ./wbm_storage_v1.0.0/data:/wbm/data \
  -B ./wbm_storage_v1.0.0/data_init:/wbm/data_init \
  -B ./wbm_storage_v1.0.0/spool:/wbm/spool \
  -B ./wbm_storage_v1.0.0/wbm_output:/wbm/wbm_output \
  -B ./wbm_storage_v1.0.0/WBM_run_state:/wbm/WBM_run_state \
  -B ./wbm_storage_v1.0.0/wbm_init:/wbm/wbm_init \
  -B ./wbm_storage_v1.0.0/model:/wbm/model \
  -B ./wbm_storage_v1.0.0/utilities:/wbm/utilities \
  -B ./wbm_storage_v1.0.0/gdal_test_files:/wbm/gdal_test_files \
  ./wbm_opensource_v1.0.0.sif wbm_os_instance1

  ##Accessing the instance
  singularity shell instance://wbm_os_instance1
 ```
 
 Option 2: Opening an Interactive Shell

```
singularity shell \
  -B ./wbm_storage_v1.0.0/data:/wbm/data \
  -B ./wbm_storage_v1.0.0/data_init:/wbm/data_init \
  -B ./wbm_storage_v1.0.0/spool:/wbm/spool \
  -B ./wbm_storage_v1.0.0/wbm_output:/wbm/wbm_output \
  -B ./wbm_storage_v1.0.0/WBM_run_state:/wbm/WBM_run_state \
  -B ./wbm_storage_v1.0.0/wbm_init:/wbm/wbm_init \
  -B ./wbm_storage_v1.0.0/model:/wbm/model \
  -B ./wbm_storage_v1.0.0/utilities:/wbm/utilities \
  -B ./wbm_storage_v1.0.0/gdal_test_files:/wbm/gdal_test_files \
  ./wbm_opensource_v1.0.0.sif
 ```

### 3. Prepare init files
