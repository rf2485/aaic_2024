#!/bin/bash
#SBATCH --mail-user=rf2485@nyulangone.org
#SBATCH --mail-type=ALL
#SBATCH	--gres=gpu:1
#SBATCH --time=03:00:00
#SBATCH --mem=16G
#SBATCH --array=1-3
#SBATCH -o ./slurm_output/dwi_preproc/slurm-%A_%a.out
#SBATCH --partition=radiology,gpu4_dev,gpu4_short,gpu4_medium,gpu4_long,gpu8_short,gpu8_medium,gpu8_long

module load miniconda3/gpu/4.9.2
# conda create -n camcan python=3.7
conda activate camcan
# pip install packaging
# conda install numpy
# pip install PyDesigner-DWI==1.0.0 --user
# conda install -c conda-forge pybids
# conda install -c mrtrix3 mrtrix3
# conda install pandas
# pip install dmri-amico==2.0.1
# sed '1d' dwi_over_55.tsv > subjectsfile.txt
module load fsl/.6.0.6
export LD_LIBRARY_PATH=/lib
# python3 bids_layout.py

subj_list=( sub-CC410129 sub-CC610050 sub-CC710214 )
subj_num=$(($SLURM_ARRAY_TASK_ID-1))
subj=${subj_list[$subj_num]}

python3 dwi_preproc.py $subj
