#!/bin/bash


OS_NAME=`uname`
HOST_NAME=`hostname`


  echo Working on ${HOST_NAME} using ${OS_NAME}

  export CLIPPED_WORKDIR="/squall2/MACAscratch/grid_crb"
  mkdir -vp ${CLIPPED_WORKDIR}

   export CLIPPED_WORKDIR="/squall2/MACAscratch/grid_crb"
   export CLIPPED_OUTDIR_ROOT="/projects/ECEP/LOCA_MACA_Ensembles/MACA/MACA_CHEYENNE"
   mkdir -vp ${CLIPPED_OUTDIR_ROOT}

   export CLIPPED_PREFIX=${CLIPPED_WORKDIR}"/CHEYENNE_MACA"



   # setting the Setting the Available ensembles
   #   currently only those members that have hits
   #   for all three variables!


         declare -a ENSEMBLE=(
                                 "BNU-ESM_r1i1p1"
                                 "CCSM4_r6i1p1"
                                 "CNRM-CM5_r1i1p1"
                                 "CSIRO-Mk3-6-0_r1i1p1"
                                 "CanESM2_r1i1p1"
                                 "GFDL-ESM2G_r1i1p1"
                                 "GFDL-ESM2M_r1i1p1"
                                 "HadGEM2-CC365_r1i1p1"
                                 "HadGEM2-ES365_r1i1p1"
                                 "IPSL-CM5A-LR_r1i1p1"
                                 "IPSL-CM5A-MR_r1i1p1"
                                 "IPSL-CM5B-LR_r1i1p1"
                                 "MIROC-ESM_r1i1p1"
                                 "MIROC-ESM-CHEM_r1i1p1"
                                 "MIROC5_r1i1p1"
                                 "MRI-CGCM3_r1i1p1"
                                 "NorESM1-M_r1i1p1"
                                 "bcc-csm1-1-m_r1i1p1"
                                 "bcc-csm1-1_r1i1p1"
                                 "inmcm4_r1i1p1"
                              )

         declare -a ENSEMBLE=("BNU-ESM_r1i1p1" )

         # setting the available variables

         declare -a    PARAM=(
                                "pr"
                                "tasmax"
                                "tasmin"
                                "huss"
                                "rhsmax"
                                "rhsmin"
                                "rsds"
                                "uas"
                                "vas"
                                )

         declare -a    PARAM=(
                                "pr"
                                )

   declare -a SCENARIO=( "historical" "rcp45" "rcp85" )
   declare -a SCENARIO=( "historical"  )





echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
echo
for SCEN in "${SCENARIO[@]}"
do


   for PAR in "${PARAM[@]}"
   do

      mkdir -vp ${CLIPPED_OUTDIR_ROOT}/${SCEN}/${PAR}

      export CLIPPED_OUTPREFIX=${CLIPPED_OUTDIR_ROOT}/${SCEN}/${PAR}/CHEYENNE_LOCA

      for ENS in "${ENSEMBLE[@]}"
      do

         echo nohup ncrcat -O --deflate 8 -h ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}___T*.nc ${CLIPPED_OUTPREFIX}_${PAR}_${ENS}_${SCEN}.nc
              nohup ncrcat -O --deflate 8 -h ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}___T*.nc ${CLIPPED_OUTPREFIX}_${PAR}_${ENS}_${SCEN}.nc

         # echo rm -frv ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}___T*.nc
         #      rm -frv ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}___T*.nc


         echo
         echo - - - - - - - - - - - - - - - - - - -
         echo

      done
      echo --------------------------------------
      echo
   done
   echo ======================================
   echo
done




echo "We're Out of Here Like Vladimir"
echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
