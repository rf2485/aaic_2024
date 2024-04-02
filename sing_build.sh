#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --time=03:00:00
#SBATCH --mem=32G

module load singularity/3.9.8
singularity pull docker://leonyichencai/synb0-disco:v3.0

