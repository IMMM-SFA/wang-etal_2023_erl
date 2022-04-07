#!/bin/bash
#-------- create new case ----------------------------
#tag=urban_I2000Clm50SpGs_CONUS_NLDAS2_CTL
tag=urban_I2000Clm50SpGs_CONUS_NLDAS2_AH3
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
REST_N=3
NTASKS=-8

rm -rf $CASENAME
rm -rf $RUNDIR/${tag}
cd ${BASE_DIR}/cesm/cime/scripts

#./create_newcase --case $CASENAME --res CLM_USRDAT --compset I2000Clm50SpGs --mach cori-haswell  --compiler intel --run-unsupported
./create_newcase --case $CASENAME --res CLM_USRDAT --compset I2000Clm50SpGs --mach cori-haswell  --compiler intel --project m2702 --run-unsupported

#------- in case directory ---------------------------
cd $CASENAME

./xmlchange NTASKS=${NTASKS}
./xmlchange NTASKS_ESP=1

#./xmlchange DOUT_S_SAVE_INTERIM_RESTART_FILES=TRUE
#./xmlchange DOUT_S=FALSE
./xmlchange CLM_BLDNML_OPTS='-bgc sp'
./xmlchange ATM_NCPL=24 #time step

./xmlchange DATM_MODE=CLM1PT
./xmlchange DIN_LOC_ROOT=${CESM_INPUTDATA_DIR}
./xmlchange DIN_LOC_ROOT_CLMFORC="\$DIN_LOC_ROOT/atm/datm7"
./xmlchange CLM_USRDAT_NAME=${CLM_USRDAT_NAME}
./xmlchange ATM_DOMAIN_FILE=domain.lnd.${CLM_USRDAT_NAME}_simyr2000.nc
./xmlchange LND_DOMAIN_FILE=domain.lnd.${CLM_USRDAT_NAME}_simyr2000.nc
./xmlchange DATM_CLMNCEP_YR_ALIGN=${ALIGN_YEAR}
./xmlchange DATM_CLMNCEP_YR_START=${DATM_START_YEAR}
./xmlchange DATM_CLMNCEP_YR_END=${DATM_END_YEAR}

./xmlchange RUN_STARTDATE=${START_DATA}
./xmlchange STOP_OPTION=$STOP_OPTION
./xmlchange STOP_N=$STOP_N
./xmlchange REST_OPTION=$REST_OPTION
./xmlchange REST_N=$REST_N

./xmlchange RUN_TYPE=hybrid,RUN_REFCASE=urban_I2000Clm50SpGs_CONUS_NLDAS2_spinup,RUN_REFDATE=0085-01-01

./xmlchange JOB_WALLCLOCK_TIME=24:00:00 --subgroup case.run
./xmlchange JOB_WALLCLOCK_TIME=01:00:00 --subgroup case.st_archive
#./xmlchange JOB_WALLCLOCK_TIME=00:30:00 --subgroup case.run
#./xmlchange JOB_QUEUE=debug --force

./case.setup

cp ${RUNDIR}/archive/urban_I2000Clm50SpGs_CONUS_NLDAS2_spinup/rest/0085-01-01-00000/* ${RUNDIR}/${tag}/run/ 

cp ~/greenroof_version2.3.2/* ./SourceMods/src.clm/
cp ~/greenroof_version2.3.2/user_nl_clm user_nl_clm

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

#./case.submit
