import os
import subprocess
import sys

from designer.preprocessing import mrpreproc as mrp
from designer.preprocessing import util, mrinfoutil
from designer.plotting import snrplot
from designer.fitting import dwipy as dp

### Path Handling ###
subject=sys.argv[1]
base_dir = "/gpfs/data/lazarlab/CamCan995"
project_dir = os.path.join(base_dir, "derivatives/fmap_processing/")
out_dir = os.path.join(project_dir, subject)
working_path = os.path.join(out_dir, 'working.mif')
intermediatepath = os.path.join(out_dir, 'intermediate_nifti')
nii_noisemap = os.path.join(out_dir, 'noisemap.nii')
init_nii = os.path.join(out_dir, 'dwi_raw.nii')
qcpath = os.path.join(out_dir, 'metrics_qc')
metricpath = os.path.join(out_dir, 'metrics')
fitqcpath = os.path.join(out_dir, 'fitting')

### DWI Post Fmap Preprocessing ###
step_count = 5
os.chdir(out_dir)

##B1 bias field correction
b1correct_name = 'dwi_b1correct'
b1correct_name_full = str(step_count) + '_' + b1correct_name
nii_b1correct = os.path.join(intermediatepath, b1correct_name_full + '.nii')
mif_b1correct = os.path.join(out_dir, b1correct_name_full + '.mif')

subprocess.run("dwibiascorrect ants " + working_path + " " + mif_b1correct,
               shell=True)
mrp.miftonii(
    input=mif_b1correct,
    output=nii_b1correct,
    verbose=True
            )
os.remove(working_path)
os.rename(mif_b1correct, working_path)

##CSF excluded smoothing
#create CSF mask
csfmask_name = 'csf_mask.nii'
csfmask_out = os.path.join(out_dir, csfmask_name)
mrp.csfmask(input=working_path,
           output=csfmask_out,
           method='fsl',
           verbose=True
           )
#create brain mask
brainmask_name = 'brain_mask.nii'
brainmask_out = os.path.join(out_dir, brainmask_name)
mrp.brainmask(input=working_path,
             output=brainmask_out,
             verbose=True
             )
#multiply brain mask with CSF mask
subprocess.run("mrcalc -force " + brainmask_out + " " + csfmask_out + " -mult " + csfmask_out, 
               shell=True)
#apply smoothing
step_count += 1
smoothing_name = 'dwi_smoothed'
smoothing_name_full = str(step_count) + "_" + smoothing_name
nii_smoothing = os.path.join(intermediatepath, smoothing_name_full + '.nii')
mif_smoothing = os.path.join(out_dir, smoothing_name_full + '.mif')

mrp.smooth(input=working_path,
          csfname=csfmask_out,
          output=mif_smoothing
          )
mrp.miftonii(input=mif_smoothing,
            output=nii_smoothing,
            verbose=True
            )
os.remove(working_path)
os.rename(mif_smoothing, working_path)

##Rician Noise Correction
step_count += 1
rician_name = 'dwi_rician'
rician_name = str(step_count) + '_' + rician_name
nii_rician = os.path.join(intermediatepath, rician_name + '.nii')
mif_rician = os.path.join(out_dir, rician_name + '.mif')

mrp.riciancorrect(input=working_path,
                 output=mif_rician,
                 noise=nii_noisemap
                 )
mrp.miftonii(input=mif_rician,
            output=nii_rician,
            verbose=True
            )
os.remove(working_path)
os.rename(mif_rician, working_path)

##Extract average of each shell
b0_name = 'B0'
nii_b0 = os.path.join(out_dir, b0_name + '.nii')
mrp.extractmeanbzero(input=working_path,
                    output=nii_b0,
                    verbose=True
                    )
b_shells = [x for x in mrinfoutil.shells(working_path) if x != 0]
b_names = ['B' + str(x) for x in b_shells]
b_paths = [os.path.join(out_dir, x + '.nii') for x in b_names]
for b_value, b_nii in zip(b_shells, b_paths):
    mrp.extractmeanshell(input=working_path,
                        output=b_nii,
                        shell=b_value,
                        verbose=True
                        )
    
##Save final preprocessed file
preprocessed = os.path.join(out_dir, 'dwi_preprocessed.nii')
mrp.miftonii(input=working_path,
            output=preprocessed,
            force=True,
            verbose=True
            )
os.remove(working_path)

### Compute SNR ###
files = []
files.append(init_nii)
files.append(preprocessed)

snr = snrplot.makesnr(dwilist=files,
                     noisepath=nii_noisemap,
                     maskpath=brainmask_out)
snr.makeplot(path=qcpath, smooth=True, smoothfactor=3)

### DTI and DKI Fitting ###
filetable = {'HEAD': util.DWIFile(preprocessed)}
imPath = filetable['HEAD'].getFull()
ext= '.nii'

dp.fit_regime(
    input=imPath,
    output=metricpath,
#     irlls=False,
#     akc=False,
    prefix=None,
    suffix=None,
    ext=ext,
    l_max=6,
    qcpath=fitqcpath,
    mask=brainmask_out
)

