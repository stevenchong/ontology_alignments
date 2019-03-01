library(dplyr)
library(stringr)

subDir <- "./03_comparison_tables"

df_all_labels <- read.csv(file = paste0(subDir,'/', 'all_ontologies_with_IDs.csv')) 

df_labels_for_envo <- df_all_labels %>%
	filter(ECSO_ID != "") %>% # return only ECSO labels
	filter(ENVO_labels == "") %>% # remove labels that already are in ENVO
	filter(PCO_labels == "") %>% # remove labels that are in PCO
	filter(BCO_labels == "") %>% # remove labels that are in BCO
	filter(PATO_labels == "") %>% # remove labels that are in PATO
	filter(CHEBI_labels == "") %>% # remove labels that are in CHEBI
 	filter(!str_detect(Envthes_ID, "usltercv")) %>% # remove labels that came from the US LTER CV (because they have been deprecated)
	filter(!str_detect(ECSO_ID, "oboe")) %>% # remove labels that came from OBOE
	filter(!str_detect(ECSO_labels, "measurement type")) %>% # remove labels that are measurement types in ECSO
	filter(!str_detect(ECSO_labels, "measurementtype")) %>% # remove labels that are measurement types in ECSO
	filter(!str_detect(ECSO_labels, " mov")) %>% # remove labels that are specific to ECSO
	filter(!str_detect(ECSO_labels, " mstmip")) # remove labels that are specific to ECSO

# Create CSV showing filtered list of ECSO labels
write.csv(df_labels_for_envo, file = paste0(subDir,"/", "potential_labels_for_ENVO.csv"), row.names = FALSE)

# Create CSV showing unique list of ECSO labels
df_unique_labels_for_envo <- df_labels_for_envo %>%
	distinct(label, .keep_all = TRUE)

write.csv(df_unique_labels_for_envo, file = paste0(subDir,"/", "unique_potential_labels_for_ENVO.csv"), row.names = FALSE)


