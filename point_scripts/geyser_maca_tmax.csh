#!/bin/bash
#SBATCH --job-name=MACA
#SBATCH --ntasks=1
#SBATCH --ntasks-per-node=1
#SBATCH --time=24:00:00
#SBATCH --mem=100000
#SBATCH --account=USDM0004
#SBATCH --output=MACA_.%J.out
#SBATCH --error=MACA_.%J.err
#SBATCH --mail-user=William.Capehart@sdsmt.edu
#SBATCH --mail-type=ALL
#SBATCH --verbose

export BUILD_VERSION="default_build"
export LOCATION_NAME="BHLS"
export VARIABLE_NAME="tmax"



### Initialize the Slurm environment
source /glade/u/apps/opt/slurm_init/init.sh

echo Processing MACA ${VARIABLE_NAME} data for ${LOCATION_NAME}

if [ $BUILD_VERSION = "nightly_build" ]; then

   echo Using Nightly Build of NCL

   ### this is the nightly build of NCL
   module use /glade/apps/contrib/ncl-nightly/modules
   module load ncltest

else

   echo Using Default Build of NCL


   ### this is the "default" build of NCL
   module load  ncl

fi

which ncl
ncl -V

# cd /glade/u/home/capehart/code/MACA/MACA_Processing_Scripts
cd /glade/p/work/capehart/MACA/MACA_Processing_Scripts

ncl ./maca_import_2d_tmax.ncl

echo "We're Out of Here Like Vladimir"
