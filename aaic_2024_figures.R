source("6_group_means.R")
library(ggpubr)
# library(effectsize)

final <- dwi_over_55 %>% 
  filter(!participant_id %in% failed_qc) 
final$SCD <- factor(final$SCD,
                    levels = c(1,0),
                    labels = c('SCD', 'Control'))
final$Income <- factor(final$homeint_v15,
                       levels = c("D", "B", "C", "A", "F", "E"),
                       labels = c("Less than  £18000", 
                                  "£18000 to 30999", 
                                  "£31000 to 51999",
                                  "£52000 to 100000",
                                  "Greater than £100000",
                                  "Prefer not to answer"))
final$Ethnicity <- factor(final$homeint_v24,
                          levels = c(1,2,3,4,6),
                          labels = c("White", "Mixed", "Asian", "Black", "Other"))
attr(final$homeint_v74, 'label') <- "Age education completed"
attr(final$sex, 'label') <- 'Sex'
attr(final$age, 'label') <- 'Age'
demo_table <- tableby(SCD ~ sex + age + Income + Ethnicity + homeint_v74, 
                      data = final, total = F)
summary(demo_table, text = TRUE)
write2word(demo_table, "demo_table.docx")

##boxplots
ggboxplot(dki_mk, x = "SCD", y = c("ctx.rh.caudalanteriorcingulate", "ctx.rh.pericalcarine"),
          panel.labs = list(.y. = c("R Caudal Anterior Cingulate", "R Pericalcarine")),
          error.plot = "errorbar",add = "jitter", add.params = list(color = "SCD"), legend = "none", combine = T) +
  stat_compare_means(label.x.npc = "center", hide.ns = T,
                     aes(label = paste0("p = ", after_stat(p.format)))) +
  labs(y = "MK", title =  "Mean Kurtosis (MK)", 
       ) +
  theme(plot.title = element_text(hjust = 0.5),
        axis.title.x = element_blank()
        )

ggboxplot(dki_rk, x = "SCD", y = c("ctx.rh.caudalanteriorcingulate", "ctx.rh.posteriorcingulate", "ctx.rh.frontalpole"),
          panel.labs = list(.y. = c("R Caudal Anterior Cingulate", "R Posterior Cingulate", "R Frontal Pole")),
          error.plot = "errorbar",add = "jitter", add.params = list(color = "SCD"), legend = "none", combine = T) +
  stat_compare_means(label.x.npc = "center", hide.ns = T,
                     aes(label = paste0("p = ", after_stat(p.format)))) +
  labs(y = "RK", title =  "Radial Kurtosis (RK)", 
  ) +
  theme(plot.title = element_text(hjust = 0.5),
        axis.title.x = element_blank()
  )

gg <- ggboxplot(dki_ak, x = "SCD", y = c("ctx.lh.paracentral", "ctx.lh.pericalcarine", "ctx.rh.lateraloccipital", "ctx.rh.lateralorbitofrontal"),
          error.plot = "errorbar",add = "jitter", add.params = list(color = "SCD"), legend = "none", combine = T) +
  stat_compare_means(label.x.npc = "center", hide.ns = T,
                     aes(label = paste0("p = ", after_stat(p.format)))) +
  labs(y = "AK", title =  "Axial Kurtosis (AK)", 
  ) +
  theme(plot.title = element_text(hjust = 0.5),
        axis.title.x = element_blank()
  )
facet(gg, facet.by = ".y.", nrow=1,
      panel.labs = list(.y. = c("L Paracentral", "L Pericalcarine", "R Lateral Occipital", "R Lateral Orbitofrontal")),
)

gg <- ggboxplot(fit_FWF, x = "SCD", y = c("Left.VentralDC", "ctx.lh.lateralorbitofrontal","ctx.lh.transversetemporal", "Right.Putamen", "ctx.rh.lateralorbitofrontal"),
          error.plot = "errorbar",add = "jitter", add.params = list(color = "SCD"), legend = "none", combine = T) +
  stat_compare_means(label.x.npc = "center", hide.ns = T,
                     aes(label = paste0("p = ", after_stat(p.format)))) +
  labs(y = "FW", title =  "Free Water Fraction (FW)", 
  ) +
  theme(plot.title = element_text(hjust = 0.5),
        axis.title.x = element_blank()
  )
facet(gg, facet.by = ".y.", nrow=1,
      panel.labs = list(.y. = c("L Ventral Diencephalon", "L Lateral Orbitofrontal", "L Transverse temporal", "R Putamen", "R Lateral Orbitofrontal")),
)

gg <- ggboxplot(fit_ODI, x = "SCD", y = c("ctx.lh.lateralorbitofrontal", "ctx.lh.transversetemporal", "ctx.lh.pericalcarine", "Right.Pallidum", "Right.VentralDC", "ctx.rh.pericalcarine"),
          error.plot = "errorbar",add = "jitter", add.params = list(color = "SCD"), legend = "none", combine = T) +
  stat_compare_means(label.x.npc = "center", hide.ns = T,
                     aes(label = paste0("p = ", after_stat(p.format)))) +
  labs(y = "OD", title =  "Orientation Dispersion (OD)", 
  ) +
  theme(plot.title = element_text(hjust = 0.5),
        axis.title.x = element_blank()
  )
facet(gg, facet.by = ".y.", nrow=1,
      panel.labs = list(.y. = c("L Lateral Orbitofrontal", "L Transverse temporal", "L Pericalcarine", "R Pallidum", "R Ventral Diencephalon", "R Pericalcarine")),
)
ggboxplot(fit_NDI, x = "SCD", y = c("ctx.rh.superiorfrontal", "ctx.rh.frontalpole"),
          panel.labs = list(.y. = c("R Superior Frontal", "R Frontal Pole")),
          error.plot = "errorbar",add = "jitter", add.params = list(color = "SCD"), legend = "none", combine = T) +
  stat_compare_means(label.x.npc = "center", hide.ns = T,
                     aes(label = paste0("p = ", after_stat(p.format)))) +
  labs(y = "ND", title =  "Neurite Density (ND)", 
  ) +
  theme(plot.title = element_text(hjust = 0.5),
        axis.title.x = element_blank()
  )

gg <- ggboxplot(dti_fa, x = "SCD", y = c("Left.Caudate", "Left.Putamen", "ctx.lh.lateralorbitofrontal", "ctx.lh.transversetemporal", "Right.Caudate", "Right.Putamen", "ctx.rh.medialorbitofrontal"),
          error.plot = "errorbar",add = "jitter", add.params = list(color = "SCD"), legend = "none", combine = T) +
  stat_compare_means(label.x.npc = "center", hide.ns = T,
                     aes(label = paste0("p = ", after_stat(p.format)))) +
  labs(y = "FA", title =  "Fractional Anisotropy (FA)", 
  ) +
  theme(plot.title = element_text(hjust = 0.5),
        axis.title.x = element_blank()
  )
facet(gg, facet.by = ".y.", nrow=1,
      panel.labs = list(.y. = c("L Caudate", "L Putamen", "L Lateral Orbitofrontal", "L Transverse Temporal", "R Caudate", "R Putamen", "R Medial Orbitofrontal")),
)

gg <- ggboxplot(dti_rd, x = "SCD", y = c("Left.Thalamus", "Left.Accumbens.area", "ctx.lh.lateralorbitofrontal", "ctx.lh.transversetemporal", "Right.Putamen", "Right.Pallidum", "ctx.rh.lateralorbitofrontal"),
                error.plot = "errorbar",add = "jitter", add.params = list(color = "SCD"), legend = "none", combine = T) +
  stat_compare_means(label.x.npc = "center", hide.ns = T,
                     aes(label = paste0("p = ", after_stat(p.format)))) +
  labs(y = "RD", title =  "Radial Diffusivity (RD)", 
  ) +
  theme(plot.title = element_text(hjust = 0.5),
        axis.title.x = element_blank()
  )
facet(gg, facet.by = ".y.", nrow=1,
      panel.labs = list(.y. = c("L Thalamus", "L Accumbens", "L Lateral Orbitofrontal", "L Transverse Temporal", "R Caudate", "R Putamen", "R Lateral Orbitofrontal")),
)

ggboxplot(dti_ad, x = "SCD", y = c("Left.Thalamus", "ctx.lh.lateralorbitofrontal", "ctx.lh.transversetemporal", "ctx.rh.lateralorbitofrontal"),
          panel.labs = list(.y. = c("L Thalamus", "L Lateral Orbitofrontal", "L Transverse Temporal", "R Lateral Orbitofrontal")),
                error.plot = "errorbar",add = "jitter", add.params = list(color = "SCD"), legend = "none", combine = T) +
  stat_compare_means(label.x.npc = "center", hide.ns = T,
                     aes(label = paste0("p = ", after_stat(p.format)))) +
  labs(y = "AD", title =  "Axial Diffusivity (AD)", 
  ) +
  theme(plot.title = element_text(hjust = 0.5),
        axis.title.x = element_blank()
  )

gg <- ggboxplot(dti_md, x = "SCD", y = c("Left.Thalamus", "ctx.lh.lateralorbitofrontal", "ctx.lh.transversetemporal", "Right.Putamen", "ctx.rh.lateralorbitofrontal"),
                error.plot = "errorbar",add = "jitter", add.params = list(color = "SCD"), legend = "none", combine = T) +
  stat_compare_means(label.x.npc = "center", hide.ns = T,
                     aes(label = paste0("p = ", after_stat(p.format)))) +
  labs(y = "MD", title =  "Mean Diffusivity (MD)", 
  ) +
  theme(plot.title = element_text(hjust = 0.5),
        axis.title.x = element_blank()
  )
facet(gg, facet.by = ".y.", nrow=1,
      panel.labs = list(.y. = c("L Thalamus", "L Lateral Orbitofrontal", "L Transverse Temporal", "R Putamen", "R Lateral Orbitofrontal")),
)
