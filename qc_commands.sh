cd /gpfs/data/lazarlab/CamCan995/derivatives/fmap_processing/
module load fsl/.6.0.6
export LD_LIBRARY_PATH=/lib
export FREESURFER_HOME=/gpfs/share/apps/freesurfer/7.4.1/raw/freesurfer/
module load freesurfer/7.4.1
subj_list=$(cut -f1 subjectsfile.txt)
subj_list=($subj_list)

mkdir -p group_qc/fmap

slicesdir sub-CC*/intermediate_nifti/1_dwi_denoised.nii
mv slicesdir group_qc/1_dwi_denoised
# firefox group_qc/1_dwi_denoised/index.html

slicesdir sub-CC*/noisemap.nii
mv slicesdir group_qc/noisemap
# firefox group_qc/noisemap/index.html

slicesdir sub-CC*/intermediate_nifti/2_dwi_degibbs.nii
mv slicesdir group_qc/2_dwi_degibbs
# firefox group_qc/2_dwi_degibbs/index.html

slicesdir sub-CC*/intermediate_nifti/3_dwi_undistorted.nii
mv slicesdir group_qc/3_dwi_undistorted
# firefox group_qc/3_dwi_undistorted/index.html
# eddy_squad sub-CC*/metrics_qc/eddy/quad -o group_qc/squad


slicesdir sub-CC*/fmap/1_mag_std.nii
mv slicesdir group_qc/fmap/1_mag_std
# firefox group_qc/fmap/1_mag_std/index.html

first_roi_slicesdir sub-CC*/fmap/1_mag_std.nii sub-CC*/fmap/2_mag_brain.nii
mv slicesdir group_qc/fmap/2_mag_brain
# firefox group_qc/fmap/2_mag_brain/index.html

first_roi_slicesdir sub-CC*/fmap/1_mag_std.nii sub-CC*/fmap/2_mag_brain_eroded.nii
# slicesdir sub-CC*/fmap/2_mag_brain_eroded.nii
mv slicesdir group_qc/fmap/2_mag_brain_eroded
# firefox group_qc/fmap/2_mag_brain_eroded/index.html

first_roi_slicesdir sub-CC*/fmap/1_mag_std.nii sub-CC*/fmap/3_mag_head.nii
# slicesdir sub-CC*/fmap/3_mag_head.nii
mv slicesdir group_qc/fmap/3_mag_head
# firefox group_qc/fmap/3_mag_head/index.html

slicesdir sub-CC*/fmap/4_t1_std.nii
mv slicesdir group_qc/fmap/4_t1_std
# firefox group_qc/fmap/4_t1_std/index.html

slicesdir sub-CC*/fmap/5t1_biascorr.nii
mv slicesdir group_qc/fmap/5_t1_biascorr
# firefox group_qc/fmap/5_t1_biascorr/index.html

first_roi_slicesdir sub-CC*/fmap/5t1_biascorr.nii sub-CC*/fmap/6_t1_brain.nii
mv slicesdir group_qc/fmap/6_t1_brain
# firefox group_qc/fmap/6_t1_brain/index.html

slicesdir sub-CC*/fmap/7_phase_std.nii
mv slicesdir group_qc/fmap/7_phase_std
# firefox group_qc/fmap/7_phase_std/index.html

slicesdir sub-CC*/fmap/8_fmap.nii
mv slicesdir group_qc/fmap/8_fmap
# firefox group_qc/fmap/8_fmap/index.html

slicesdir sub-CC*/fmap/9vsm.nii
mv slicesdir group_qc/fmap/9_vsm
# firefox group_qc/fmap/9_vsm/index.html

slicesdir sub-CC*/intermediate_nifti/4_dwi_unwarp.nii
mv slicesdir group_qc/4_dwi_unwarp
# firefox group_qc/4_dwi_unwarp/index.html


slicesdir sub-CC*/intermediate_nifti/5_dwi_b1correct.nii
mv slicesdir group_qc/5_dwi_b1correct
# firefox group_qc/5_dwi_b1correct/index.html

# first_roi_slicesdir sub-CC*/intermediate_nifti/5_dwi_b1correct.nii sub-CC*/csf_mask.nii
# mv slicesdir group_qc/csf_mask
# firefox group_qc/csf_mask/index.html

mkdir -p group_qc/csf_mask
echo '<HTML><TITLE>csf_mask</TITLE><BODY BGCOLOR="#458dd1">' > group_qc/csf_mask/index.html
for subj in "${subj_list[@]}"; do
	freeview -v $subj/intermediate_nifti/5_dwi_b1correct.nii $subj/csf_mask.nii:colormap=heat:opacity=0.2 -viewport z -ss 	group_qc/csf_mask/${subj}.png
	echo '<a href="'${subj}'.png"><img src="'${subj}'.png" WIDTH=1000 >' ${subj}'</a><br>' >> group_qc/csf_mask/index.html
done
echo '</BODY></HTML>' >> group_qc/csf_mask/index.html
# firefox group_qc/csf_mask/index.html

# first_roi_slicesdir sub-CC*/intermediate_nifti/5_dwi_bicorrect.nii sub-CC*/brain_mask.nii
# mv slicesdir group_qc/brain_mask
# firefox group_qc/brain_mask/index.html
mkdir -p group_qc/brain_mask
echo '<HTML><TITLE>brain_mask</TITLE><BODY BGCOLOR="#458dd1">' > group_qc/brain_mask/index.html
for subj in "${subj_list[@]}"; do
	freeview -v $subj/intermediate_nifti/5_dwi_b1correct.nii $subj/brain_mask.nii:colormap=heat:opacity=0.2 -viewport z -ss 	group_qc/brain_mask/${subj}.png
	echo '<a href="'${subj}'.png"><img src="'${subj}'.png" WIDTH=1000 >' ${subj}'</a><br>' >> group_qc/brain_mask/index.html
done
echo '</BODY></HTML>' >> group_qc/brain_mask/index.html
# firefox group_qc/brain_mask/index.html

slicesdir sub-CC*/intermediate_nifti/6_dwi_smoothed.nii
mv slicesdir group_qc/6_dwi_smoothed
# firefox group_qc/6_dwi_smoothed/index.html

slicesdir sub-CC*/intermediate_nifti/7_dwi_rician.nii
mv slicesdir group_qc/7_dwi_rician
# firefox group_qc/7_dwi_rician/index.html

slicesdir sub-CC*/B0.nii
mv slicesdir group_qc/B0
# firefox group_qc/B0/index.html

slicesdir sub-CC*/B1000.nii
mv slicesdir group_qc/B1000
# firefox group_qc/B1000/index.html

slicesdir sub-CC*/B2000.nii
mv slicesdir group_qc/B2000
# firefox group_qc/B2000/index.html

mkdir -p group_qc/snrplots
mkdir -p group_qc/irlls_outliers_plots
echo '<HTML><TITLE>snrplots</TITLE><BODY BGCOLOR="#458dd1">' > group_qc/snrplots/index.html
echo '<HTML><TITLE>outliersplots</TITLE><BODY BGCOLOR="#458dd1">' > group_qc/irlls_outliers_plots/index.html
for subj in "${subj_list[@]}"; do
	cp $subj/metrics_qc/SNR.png group_qc/snrplots/${subj}.png
	echo '<a href="'${subj}'.png"><img src="'${subj}'.png" WIDTH=500 >' ${subj}'</a><br>' >> group_qc/snrplots/index.html
	cp $subj/fitting/irlls_outliers_plot.png group_qc/irlls_outliers_plots/${subj}.png
	echo '<a href="'${subj}'.png"><img src="'${subj}'.png" WIDTH=500 >' ${subj}'</a><br>' >> group_qc/irlls_outliers_plots/index.html
done
echo '</BODY></HTML>' >> group_qc/snrplots/index.html
echo '</BODY></HTML>' >> group_qc/irlls_outliers_plots/index.html
# firefox group_qc/snrplots/index.html
# firefox group_qc/irlls_outliers_plots/index.html

slicesdir sub-CC*/fitting/outliers_akc.nii
mv slicesdir group_qc/outliers_akc
# firefox group_qc/outliers_akc/index.html

pyd_list=( dki_ak dki_kfa dki_mk dki_mkt dki_odf dki_rk dki_trace DT dti_ad dti_fa dti_fe dti_md dti_odf dti_rd dti_trace KT wmti_awf wmti_eas_ad wmti_eas_rd wmti_eas_tort wmti_ias_da )
for meas in "${pyd_list[@]}"; do
	slicesdir sub-CC*/metrics/${meas}.nii
	mv slicesdir group_qc/$meas
	# firefox group_qc/$meas/index.html
done

mkdir -p group_qc/dti_fa
mkdir -p group_qc/dti_fe
echo '<HTML><TITLE>dti_fa</TITLE><BODY BGCOLOR="#458dd1">' > group_qc/dti_fa/index.html
echo '<HTML><TITLE>dti_fe</TITLE><BODY BGCOLOR="#458dd1">' > group_qc/dti_fe/index.html
for subj in "${subj_list[@]}"; do
	freeview -v $subj/metrics/dti_fa.nii -viewport z -ss group_qc/dti_fa/${subj}.png
	echo '<a href="'${subj}'.png"><img src="'${subj}'.png" WIDTH=500 >' ${subj}'</a><br>' >> group_qc/dti_fa/index.html
	freeview -v $subj/metrics/dti_fe.nii -viewport z -ss group_qc/dti_fe/${subj}.png	
	echo '<a href="'${subj}'.png"><img src="'${subj}'.png" WIDTH=500 >' ${subj}'</a><br>' >> group_qc/dti_fe/index.html
done
echo '</BODY></HTML>' >> group_qc/dti_fa/index.html
echo '</BODY></HTML>' >> group_qc/dti_fe/index.html
# firefox group_qc/dti_fa/index.html
# firefox group_qc/dti_fe/index.html

noddi_list=( fit_dir fit_FWF fit_NDI fit_ODI )
for meas in "${noddi_list[@]}"; do
	slicesdir sub-CC*/AMICO/NODDI/${meas}.nii.gz
	mv slicesdir group_qc/$meas
	# firefox group_qc/$meas/index.html
done

mkdir -p group_qc/freesurfer/recon
echo '<HTML><TITLE>fs_recon</TITLE><BODY BGCOLOR="#458dd1">' > group_qc/freesurfer/recon/index.html
for subj in "${subj_list[@]}"; do	
	freeview -v freesurfer/$subj/mri/native.mgz freesurfer/$subj/mri/aparc+aseg.mgz:colormap=lut:opacity=0.2 -viewport z -ss 	group_qc/freesurfer/recon/${subj}.png
	echo '<a href="'${subj}'.png"><img src="'${subj}'.png" WIDTH=500 >' ${subj}'</a><br>' >> group_qc/freesurfer/recon/index.html
done
echo '</BODY></HTML>' >> group_qc/freesurfer/recon/index.html
# firefox group_qc/freesurfer/recon/index.html

for subj in "${subj_list[@]}"; do
	mkdir -p group_qc/freesurfer/aparc+aseg2B0
	freeview -v freesurfer/$subj/diffusion/B0.nii freesurfer/$subj/diffusion/aparc+aseg2diff.mgz:colormap=lut:opacity=0.2 -view z -ss group_qc/freesurfer/aparc+aseg2B0/${subj}.png
done
