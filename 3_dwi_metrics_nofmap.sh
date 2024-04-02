#!/bin/bash
#SBATCH --mail-user=rf2485@nyulangone.org
#SBATCH --mail-type=ALL
#SBATCH --time=3-00:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --tasks-per-node=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=32G
#SBATCH --array=1-3
#SBATCH -o ./slurm_output/dwi_post_fmap/slurm-%A_%a.out

module load miniconda3/gpu/4.9.2
# conda create -n camcan python=3.7
conda activate camcan
# pip install packaging
# conda install numpy
# pip install PyDesigner-DWI --user
# conda install -c mrtrix3 mrtrix3
# pip install dmri-amico==2.0.1
module load fsl/.6.0.6
export LD_LIBRARY_PATH=/lib
module load ants/2.1.0

subj_list=( sub-CC410129 sub-CC610050 sub-CC710214 )
subj_num=$(($SLURM_ARRAY_TASK_ID-1))
subj=${subj_list[$subj_num]}

basedir=/gpfs/data/lazarlab/CamCan995
rawdir=$basedir/raw
projectdir=$basedir/derivatives/fmap_processing

python3 $projectdir/dwi_post_fmap.py $subj
