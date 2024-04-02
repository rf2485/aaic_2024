from bids.layout import BIDSLayout
import os
import pandas as pd

## path handling
base_dir = "/Volumes/Research/lazarm03lab/labspace/AD/camcan995"
cluster_dir = "/gpfs/data/lazarlab/CamCan995"
raw_data = os.path.join(base_dir, "raw")
project_dir = os.path.join(base_dir, "derivatives/fmap_processing/")
file_df_path = os.path.join(project_dir, "file_df.csv")

## bids layout
# layout = BIDSLayout(raw_data) # generate layout (takes a long time)
# layout.save(project_dir) # save to file so we don't have to do it again
# file_df = layout.to_df() # create df that represents layout (takes a long time)
# file_df.to_csv(file_df_path, index=False)

## replace base_dir with cluster_dir
file_df = pd.read_csv(file_df_path)
file_list = file_df.path
file_list = [f.replace(base_dir, cluster_dir) for f in file_list]
file_df.path = file_list
file_df.to_csv(file_df_path, index=False) # save to file