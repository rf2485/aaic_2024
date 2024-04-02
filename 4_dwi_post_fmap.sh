#!/bin/bash
#SBATCH --mail-user=rf2485@nyulangone.org
#SBATCH --mail-type=ALL
#SBATCH --time=3-00:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --tasks-per-node=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=32G
#SBATCH --array=1-322
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

subj_list=$(cut -f1 subjectsfile.txt)
subj_list=($subj_list)
subj_num=$(($SLURM_ARRAY_TASK_ID-1))
subj=${subj_list[$subj_num]}

basedir=/gpfs/data/lazarlab/CamCan995
rawdir=$basedir/raw
projectdir=$basedir/derivatives/fmap_processing
freesurferdir=$projectdir/freesurfer
mkdir -p $freesurferdir

#complete PyDesigner pipeline
python3 $projectdir/dwi_post_fmap.py $subj

#fit NODDI
python3 $projectdir/amico_noddi.py $subj

#FreeSurfer segmentation
module load freesurfer/7.4.1
export SUBJECTS_DIR=$freesurferdir

if ! [ -f $freesurferdir/$subj/surf/rh.pial.T1 ]; then
	recon-all-clinical.sh $rawdir/$subj/anat/${subj}_T1w.nii.gz $subj 4 $freesurferdir
	mkdir -p $freesurferdir/$subj/mri/orig
	mri_convert $rawdir/$subj/anat/${subj}_T1w.nii.gz $freesurferdir/$subj/mri/orig/001.mgz
	cp $freesurferdir/$subj/surf/lh.pial $freesurferdir/$subj/surf/lh.pial.T1
	cp $freesurferdir/$subj/surf/rh.pial $freesurferdir/$subj/surf/rh.pial.T1
fi

if ! [ -f $freesurferdir/$subj/label/rh.entorhinal_exvivo.label ]; then
	recon-all -T2 $rawdir/$subj/anat/${subj}_T2w.nii.gz -motioncor -talairach -nuintensitycor -normalization -gcareg -maskbfs -T2pial -cortribbon -parcstats -cortparc2 -parcstats2 -cortparc3 -parcstats3 -pctsurfcon -hyporelabel -aparc2aseg -apas2aseg -segstats -wmparc -balabels -subjid ${subj} -sd ${freesurferdir} -threads 4
fi

#register FreeSurfer to template
# if ! [ -f $freesurferdir/$subj/cvs/final_CVSmorph_tocvs_avg35_inMNI152.m3z ]; then
# 	mri_cvs_register --mov ${subj} --mni
# fi
#NOTE: this did a terrible job, try mri_easyreg instead

#register diffusion to FreeSurfer
if ! [ -f $freesurferdir/$subj/diffusion/aparc+aseg2diff.mgz ]; then
	cd $freesurferdir/$subj/
	mkdir -p diffusion
	cp $projectdir/$subj/B0.nii diffusion/
	bbregister --s ${subj} --mov diffusion/B0.nii --reg diffusion/b02fs.lta --dti --init-fsl
	mri_vol2vol --mov diffusion/B0.nii --targ mri/aparc+aseg.mgz --inv --interp nearest --o diffusion/aparc+aseg2diff.mgz --reg diffusion/b02fs.lta --no-save-reg
fi

pyd_list=( dki_ak dki_kfa dki_mk dki_mkt dki_odf dki_rk dki_trace DT dti_ad dti_fa dti_fe dti_md dti_odf dti_rd dti_trace KT wmti_awf wmti_eas_ad wmti_eas_rd wmti_eas_tort wmti_ias_da )
for meas in "${pyd_list[@]}"; do
	if ! [ -f $freesurferdir/$subj/stats/aparc+aseg2${meas}.stats ]; then
		cp $projectdir/$subj/metrics/${meas}.nii $freesurferdir/$subj/diffusion/
		#brain-only diffusion metric images using aparc+aseg2diff as the mask
		mri_mask $freesurferdir/$subj/diffusion/${meas}.nii $freesurferdir/$subj/diffusion/aparc+aseg2diff.mgz $freesurferdir/$subj/diffusion/${meas}_masked.mgz	
		#register diffusion to template	
		# mri_vol2vol --targ $FREESURFER_HOME/subjects/cvs_avg35_inMNI152/mri/norm.mgz --m3z $freesurferdir/$subj/cvs/final_CVSmorph_tocvs_avg35_inMNI152.m3z --noDefM3zPath --reg $freesurferdir/$subj/diffusion/b02fs.lta --mov $freesurferdir/$subj/diffusion/${meas}_masked.mgz --o $freesurferdir/$subj/diffusion/${meas}_masked2cvs_inMNI.mgz --interp trilin --no-save-reg
		#generate ROI stats
		mri_segstats --seg $freesurferdir/$subj/diffusion/aparc+aseg2diff.mgz --ctab $FREESURFER_HOME/FreeSurferColorLUT.txt --i $freesurferdir/$subj/diffusion/${meas}.nii --sum $freesurferdir/$subj/stats/aparc+aseg2${meas}.stats
	fi
done

noddi_list=( fit_dir fit_FWF fit_NDI fit_ODI )
for meas in "${noddi_list[@]}"; do
	if ! [ -f $freesurferdir/$subj/stats/aparc+aseg2${meas}.stats ]; then
		cp $projectdir/$subj/AMICO/NODDI/${meas}.nii.gz $freesurferdir/$subj/diffusion/
		mri_mask $freesurferdir/$subj/diffusion/${meas}.nii.gz $freesurferdir/$subj/diffusion/aparc+aseg2diff.mgz $freesurferdir/$subj/diffusion/${meas}_masked.mgz
		# mri_vol2vol --targ $FREESURFER_HOME/subjects/cvs_avg35_inMNI152/mri/norm.mgz --m3z $freesurferdir/$subj/cvs/final_CVSmorph_tocvs_avg35_inMNI152.m3z --noDefM3zPath --reg $freesurferdir/$subj/diffusion/b02fs.lta --mov $freesurferdir/$subj/diffusion/${meas}_masked.mgz --o $freesurferdir/$subj/diffusion/${meas}_masked2cvs_inMNI.mgz --interp trilin --no-save-reg
		mri_segstats --seg $freesurferdir/$subj/diffusion/aparc+aseg2diff.mgz --ctab $FREESURFER_HOME/FreeSurferColorLUT.txt --i $freesurferdir/$subj/diffusion/${meas}.nii.gz --sum $freesurferdir/$subj/stats/aparc+aseg2${meas}.stats
	fi
done