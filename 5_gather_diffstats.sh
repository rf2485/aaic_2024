#!/bin/bash
#SBATCH --mail-user=rf2485@nyulangone.org
#SBATCH --mail-type=ALL
#SBATCH --time=4:00:00
#SBATCH --mem=4G
#SBATCH -o ./slurm_output/diffstats/slurm-%j.out
#SBATCH --partition=radiology

basedir=/gpfs/data/lazarlab/CamCan995
rawdir=$basedir/raw
projectdir=$basedir/derivatives/fmap_processing
freesurferdir=$projectdir/freesurfer

module load freesurfer/7.4.1
export SUBJECTS_DIR=$freesurferdir

cut -f1 subjectsfile.txt > $freesurferdir/subjectlist.txt
cd $freesurferdir

aparcstats2table --subjectsfile=subjectlist.txt --hemi lh --tablefile=lh_aparctable.tsv --measure=thickness --common-parcs
aparcstats2table --subjectsfile=subjectlist.txt --hemi rh --tablefile=rh_aparctable.tsv --measure=thickness --common-parcs
asegstats2table --subjectsfile=subjectlist.txt --tablefile=asegtable.tsv --common-segs
asegstats2table --subjectsfile=subjectlist.txt --stats=wmparc.stats --tablefile=wmparctable.tsv --common-segs

meas_list=( dki_ak dki_kfa dki_mk dki_mkt dki_odf dki_rk dki_trace DT dti_ad dti_fa dti_fe dti_md dti_odf dti_rd dti_trace KT wmti_awf wmti_eas_ad wmti_eas_rd wmti_eas_tort wmti_ias_da fit_dir fit_FWF fit_NDI fit_ODI )
for meas in "${meas_list[@]}"; do
	asegstats2table --subjectsfile=subjectlist.txt --meas mean --stats=aparc+aseg2${meas}.stats --tablefile=aparc+aseg2${meas}.tsv --common-segs
done
