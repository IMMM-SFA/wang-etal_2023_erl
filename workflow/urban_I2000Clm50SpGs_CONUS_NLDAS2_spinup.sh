#!/bin/bash
#-------- create new case ----------------------------
tag=urban_I2000Clm50SpGs_CONUS_NLDAS2_spinup
BASE_DIR=/global/project/projectdirs/m2702/wangly
CASENAME=${BASE_DIR}/urban_runs/${tag}
RUNDIR=/global/cscratch1/sd/wangly
CLM_USRDAT_NAME=conus_0.125
CESM_INPUTDATA_DIR=/global/cscratch1/sd/wangly/inputdata/cesm_inputdata
START_DATA=1979-01-01
ALIGN_YEAR=1979
DATM_START_YEAR=1979
DATM_END_YEAR=1999
STOP_OPTION=nyears
STOP_N=21
REST_OPTION=nyears
REST_N=21
NTASKS=-10

rm -rf $CASENAME
rm -rf $RUNDIR/${tag}
cd ${BASE_DIR}/cesm/cime/scripts

./create_newcase --case $CASENAME --res CLM_USRDAT --compset I2000Clm50SpGs --mach cori-haswell  --compiler intel --project m2702 --run-unsupported

#------- in case directory ---------------------------
cd $CASENAME

./xmlchange NTASKS=${NTASKS}
./xmlchange NTASKS_ESP=1

./xmlchange CLM_BLDNML_OPTS='-bgc sp'
./xmlchange DATM_MODE=CLM1PT
./xmlchange DIN_LOC_ROOT=${CESM_INPUTDATA_DIR}
./xmlchange DIN_LOC_ROOT_CLMFORC="\$DIN_LOC_ROOT/atm/datm7"
./xmlchange CLM_USRDAT_NAME=${CLM_USRDAT_NAME}
./xmlchange ATM_DOMAIN_FILE=domain.lnd.${CLM_USRDAT_NAME}_simyr2000.nc
./xmlchange LND_DOMAIN_FILE=domain.lnd.${CLM_USRDAT_NAME}_simyr2000.nc
./xmlchange DATM_CLMNCEP_YR_ALIGN=${ALIGN_YEAR}
./xmlchange DATM_CLMNCEP_YR_START=${DATM_START_YEAR}
./xmlchange DATM_CLMNCEP_YR_END=${DATM_END_YEAR}

./xmlchange STOP_OPTION=$STOP_OPTION
./xmlchange STOP_N=$STOP_N
./xmlchange REST_OPTION=$REST_OPTION
./xmlchange REST_N=$REST_N

./xmlchange JOB_WALLCLOCK_TIME=48:00:00 --subgroup case.run
./xmlchange JOB_WALLCLOCK_TIME=01:00:00 --subgroup case.st_archive

./case.setup

cp ~/greenroof_version2.3.2/* ./SourceMods/src.clm/
cp ~/greenroof_version2.3.2/user_nl_clm_spinup user_nl_clm

EOF
cat >> user_nl_datm << EOF
taxmode = "cycle", "cycle", "cycle"
EOF

./case.build

# Modify datm streams
cp -f CaseDocs/datm.streams.txt.CLM1PT.CLM_USRDAT user_datm.streams.txt.CLM1PT.CLM_USRDAT
chmod +rw user_datm.streams.txt.CLM1PT.CLM_USRDAT
perl -w -i -p -e 's@RH       rh@QBOT     shum@' user_datm.streams.txt.CLM1PT.CLM_USRDAT
sed -i '/ZBOT/d' user_datm.streams.txt.CLM1PT.CLM_USRDAT

./case.submit
