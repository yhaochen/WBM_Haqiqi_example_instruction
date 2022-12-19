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

For convenience, before starting, create an empty folder where you want to install the WBM and corresponding files (this is different from the folder that stores the data). Locate to this folder (assume it's called `/My_WBM`).

### 1. Download and install the WBM 

Here we simply introduce the required steps and commands for downloading and installation. See more detailed information about the installation at: https://github.com/pches/WBM_localPSUguide/blob/main/WBM_howTo.md (credit to Matthew Lisk).


First download the WBM container and its readme file:

```
wget https://wbm.unh.edu/v1.0.0/wbm_opensource_v1.0.0.sif 
wget https://wbm.unh.edu/v1.0.0/wbm_opensource_v1.0.0_Readme.txt
```

Then download the WBM storage folder structure and its readme file:

```
wget https://wbm.unh.edu/v1.0.0/wbm_storage_v1.0.0.tar.gz
wget https://wbm.unh.edu/v1.0.0/wbm_storage_v1.0.0_Readme.txt
```

Then uncompress the storage folder file:

`tar -xvzf ./wbm_storage_v1.0.0.tar.gz`

After this step you should see a folder called `wbm_storage_v1.0.0`. 

### 2. Create a WBM container and verify WBM installation

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

If you build the container successfully, you should see **"singularity>"** now in your terminal (instead of the normal folder path). The template folder `/wbm_storage_v1.0.0` you downloaded contains the basic storage folder structure and some test data to help users check whether the model is successfully installed. If you want to verify the model installation, please run the following command:

`/wbm/model/wbm.pl -v /wbm/wbm_init/test.ini`

And you should see the following messages after some time:

```
Summary for Year 2000: 
Rff-Gl/Precip  Yr = (8.24 / 15.84), 52.03 % 
Runoff-Dischg  Yr = (8.24 - 8.21), 0.03 km3
ET Non/Irr/Rfd Yr = (7.60 / 0.00 / 0.00) km3
Surface W Storage =  0.03 km3
Grndwater Storage =  0.65 km3

Y=2000 Spool files added = 0
    Run state is saved.
```

If you see the above messages, it means the WBM works. Then you can delete all the files inside the following subfolders inside `wbm_storage_v1.0.0` (because we will change them when running the Haqiqi et al example):

```
/wbm_init
/spool
/data_init
/gdal_test_files
```

As a reference, the folder structure and corresponding data inside it is contained in this repository.

### 3. Prepare the data init files

WBM's model settings are controlled by different initialization files (.init files). There is a core init file that lists the other required init files. The other init files point to different data and parameters. In this instruction we begin with the init files pointing to each dataset. All the data init files should be put in the  `/my_WBM/wbm_storage_v1.0.0/data_init` folder.

### 3.1. Climate data and cropland data init files

These init files are in the "/squam.sr.unh.edu/US_CDL_v3_data/data_init/" folder under the data folder. They include: 

**PRISM data: **

temperature and precipitation

**MERRA data:**

Daily and annual temperature, precipitation, cloud coverage, relative humidity, albedo, wind speed in horizontal and vertical direction, leaf area index

**CDL data:**

Cropland fraction

**MIRCA data:**

Crop area fraction

(For PSU cluster users: the path to these init files is: `/gpfs/group/kaf26/default/private/WBM_data/squam.sr.unh.edu/US_CDL_v3_data/data_init/`)

Firstly, copy these init files to the `/data_init` folder where you install the WBM (`/my_WBM/wbm_storage_v1.0.0/data_init`). 

`cp /gpfs/group/kaf26/default/private/WBM_data/squam.sr.unh.edu/US_CDL_v3_data/data_init /my_WBM/wbm_storage_v1.0.0/data_init` 

Then, for each init file, open it and change the line of "File_Path" based on the data path that this init file is pointing to. For example, for `merra_t2m_d.init` file, change this line to:

`File_Path	=> '(1e20,1e5):/gpfs/scratch/hxy46/Haqiqi_example/data/squam.sr.unh.edu/US_CDL_v3_data/climate/MERRA_ATM/_YEAR_/MERRA.prod.assim.tavg1_2d_slv_Nx._YEAR__MONTH__DAY_.SUB.nc;'`

where "_YEAR_" "_MONTH_" "_DAY_" automatically searches for each year, month and day from the start date to the end date (the 3rd and 4th line in the init file). Make sure the file path is correct, and the "Var_Name" line is consistent with the variable name in the .nc files that this init file is pointing to.

### 5. Prepare the core init file

 This core init file can be found as "US_CDL_v3.init" in this repository.

