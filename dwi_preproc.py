import numpy as np
import os
import sys

from designer.preprocessing import mrpreproc as mrp
from designer.preprocessing import util

### path handling
subject=sys.argv[1]
base_dir = "/gpfs/data/lazarlab/CamCan995"
raw_data = os.path.join(base_dir, "raw")
project_dir = os.path.join(base_dir, "derivatives/fmap_processing/")
out_dir = os.path.join(project_dir, subject)

if not os.path.exists(out_dir):
    os.makedirs(out_dir, exist_ok=True)

working_path = os.path.join(out_dir, 'working.mif')

intermediatepath = os.path.join(out_dir, 'intermediate_nifti')
if not os.path.exists(intermediatepath):
    os.makedirs(intermediatepath, exist_ok=True)
    
qcpath = os.path.join(out_dir, 'metrics_qc')
if not os.path.exists(qcpath):
    os.makedirs(qcpath, exist_ok=True)
    
eddyqcpath = os.path.join(qcpath, 'eddy')
if not os.path.exists(eddyqcpath):
    os.makedirs(eddyqcpath, exist_ok=True)
    
tmp_dir = os.path.join(out_dir, "tmp")
if not os.path.exists(tmp_dir):
    os.makedirs(tmp_dir)
    
fitqcpath = os.path.join(out_dir, 'fitting')
if not os.path.exists(fitqcpath):
    os.makedirs(fitqcpath)
    
metricpath = os.path.join(out_dir, 'metrics')
if not os.path.exists(metricpath):
    os.makedirs(metricpath)
    
### grab files
# layout = pd.read_csv(os.path.join(project_dir, "file_df.csv")) #load bids layout for grabbing files
#grab dwi files
# dwi_raw = layout[(layout.datatype=="dwi") & (layout.extension==".nii.gz") & (layout.subject==subject)]
dwi_raw = os.path.join(raw_data, subject, "dwi", subject + "_dwi.nii.gz")
image = util.DWIParser([dwi_raw])
dwi_nii = image.cat(path=out_dir, ext='.mif') #concatenate dwi images

if np.unique(image.echotime).size > 1: #multiecho
    multi_echo = True
    multi_echo_start = [0]
    multi_echo_end = [image.vols[0] - 1]
    for idx, vols in enumerate(image.vols[1:]):
        multi_echo_start.append(multi_echo_start[-1] + vols)
        multi_echo_end.append(multi_echo_end[-1] + vols)
    multi_echo_start = [int(x) for x in multi_echo_start]
    multi_echo_end = [int(x) for x in multi_echo_end]
#save dwi images to working_path
init_nii = os.path.join(out_dir, 'dwi_raw.nii')
mrp.miftonii(input=working_path, 
             output=init_nii,
             verbose=True
            )

### DWI preprocessing ###
# based on pyDESIGNER, with an added fieldmap unwarp due to the lack of reverse phase encoded B0 images
step_count = 0 # count preprocessing step

##denoise
step_count += 1
denoised_name = 'dwi_denoised'
denoised_name_full = str(step_count)+ '_' + denoised_name
nii_denoised = os.path.join(intermediatepath, denoised_name_full + '.nii')
mif_denoised = os.path.join(out_dir, denoised_name_full + '.mif')
nii_noisemap = os.path.join(out_dir, 'noisemap.nii')

mrp.denoise(working_path, mif_denoised, noisemap=True, verbose=True)
mrp.miftonii(input=mif_denoised, output=nii_denoised)
os.remove(working_path)
os.rename(mif_denoised, working_path)

##degibbs
step_count += 1
degibbs_name = 'dwi_degibbs'
degibbs_name_full = str(step_count)+ '_' + degibbs_name
nii_degibbs = os.path.join(intermediatepath, degibbs_name_full+'.nii')
mif_degibbs = os.path.join(out_dir, degibbs_name_full+'.mif')
mrp.degibbs(input=working_path, output=mif_degibbs, verbose=True)
mrp.miftonii(input=mif_degibbs, output=nii_degibbs)
os.remove(working_path)
os.rename(mif_degibbs, working_path)

##eddy
step_count += 1
undistorted_name = 'dwi_undistorted'
undistorted_name_full = str(step_count)+ '_' + undistorted_name
nii_undistorted = os.path.join(intermediatepath, undistorted_name_full + '.nii')
mif_undistorted = os.path.join(out_dir, undistorted_name_full + '.mif')
mrp.undistort(input=working_path, output=mif_undistorted, rpe='rpe_header', qc=eddyqcpath)
mrp.miftonii(input=mif_undistorted, output=nii_undistorted)
os.remove(working_path)
os.rename(mif_undistorted, working_path)

##mean B0
tmp_b0_name = 'mean_b0'
nii_tmp_b0 = os.path.join(tmp_dir, tmp_b0_name + '.nii')
mrp.extractmeanbzero(input=working_path,
                    output=nii_tmp_b0,
                    verbose=True
                    )
