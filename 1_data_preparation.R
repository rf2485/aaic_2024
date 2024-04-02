library(tidyverse)
#replace with location for your source data from the CamCan data repository
data_dir = "/Volumes/Research/lazarm03lab/labspace/AD/camcan995/source_materials"

#replace with location of your participants.tsv
participants = read.delim("/Volumes/Research/lazarm03lab/labspace/AD/camcan995/raw/participants.tsv", tryLogical = FALSE)
participants$SCD <- participants$homeint_v230 #copy "problems with memory" answer
participants$SCD[participants$SCD == 1] <- FALSE #change to boolean
participants$SCD[participants$SCD == 2] <- TRUE
participants$SCD[is.na(participants$SCD)] <- FALSE

### filter by age, if fmap is available, and if DWI is available ###

#list of DWI participants without fmap
no_fmap = c('sub-CC610050', 'sub-CC710214', 'sub-CC410129')
#all DWI participants
#replace with location of your dwi participants.tsv
dwi_participants = read_tsv(file.path(data_dir, "imaging/dwi/participants.tsv")) %>%
  select(participant_id) %>%
  left_join(., participants, by='participant_id')
#DWI participants over age 55 with fmap
dwi_over_55 = dwi_participants %>% filter(age > 55, !participant_id %in% no_fmap)
write_tsv(dwi_over_55, "dwi_over_55.tsv") #write to file