#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --time=12:00:00
#SBATCH --mem=32G

source activate camcan_diffusion
module load fsl/6.0.5

python dwi_preproc.py
