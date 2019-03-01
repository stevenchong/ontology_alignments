### This script displays comparisons between Envthes, ENVO, ECSO, PATO, PCO, and BCO terms. The first column displays
### all unique terms present in the combined vocabularies. 

library(dplyr)
library(plyr)

### Read input subdirectory and create output subdirectory
subDir <- "./02_output_labels_files"
outputDir <- "./03_comparison_tables"

dir.create(file.path(getwd(), outputDir), showWarnings = FALSE)


##### Get labels from ECSO
# Read in csv file
df_ECSO <- read.csv(file = paste0(subDir,'/', 'ECSO8_all_labels_and_IDs.csv')) 

# Put all of the labels into a single column
df_labels <-  df_ECSO %>% 
	select (label, ID) %>%
	{ filter( . , label != "" ) } # remove rows that don't have labels

df_altLabels <- df_ECSO %>%
	dplyr::select (label = altLabel, ID)

df_prefLabels <- df_ECSO %>%
	dplyr::select (label = prefLabel, ID)

df_hiddenLabels <- df_ECSO %>%
	dplyr::select (label = hiddenLabel, ID)

df_IAO_0000118 <- df_ECSO %>%
	dplyr::select (label = IAO_0000118, ID)

df_BCO_0000060 <- df_ECSO %>%
	dplyr::select (label = BCO_0000060, ID)

df_exact_synonyms <- df_ECSO %>%
	dplyr::select (label = exact_synonym, ID)

df_related_synonyms <- df_ECSO %>%
	dplyr::select (label = related_synonym, ID)


df_ECSO_labels <- rbind(df_labels, df_prefLabels, df_altLabels, df_hiddenLabels, df_IAO_0000118, df_BCO_0000060, df_exact_synonyms, df_related_synonyms) %>%
{ data.frame(lapply( . , trimws), stringsAsFactors = FALSE) } %>% #trim any whitespace 
{ data.frame(lapply( . , tolower), stringsAsFactors = FALSE) }


df_ECSO_labels$label <- gsub("_", " ", df_ECSO_labels$label) %>% # replace '_' with a space
  { gsub("'", "", .)} %>% # remove single quotes
  { gsub("-", " ", .) } # replace hyphen with a space

df_ECSO_labels <- df_ECSO_labels %>%
	filter (label != '') %>%
	distinct() %>%
	arrange(label) # sort alphabetically

##### Get labels from BCO

# Read in csv file
df_BCO <- read.csv(file = paste0(subDir,'/', 'bco_all_labels_and_IDs.csv')) 

# Put all of the labels into a single column
df_labels <-  df_BCO %>% 
	select (label, ID) %>%
	{ filter( . , label != "" ) } # remove rows that don't have labels

df_altLabels <- df_BCO %>%
	dplyr::select (label = altLabel, ID)

df_prefLabels <- df_BCO %>%
	dplyr::select (label = prefLabel, ID)

df_hiddenLabels <- df_BCO %>%
	dplyr::select (label = hiddenLabel, ID)

df_IAO_0000118 <- df_BCO %>%
	dplyr::select (label = IAO_0000118, ID)

df_BCO_0000060 <- df_BCO %>%
	dplyr::select (label = BCO_0000060, ID)

df_exact_synonyms <- df_BCO %>%
	dplyr::select (label = exact_synonym, ID)

df_related_synonyms <- df_BCO %>%
	dplyr::select (label = related_synonym, ID)


df_BCO_labels <- rbind(df_labels, df_prefLabels, df_altLabels, df_hiddenLabels, df_IAO_0000118, df_BCO_0000060, df_exact_synonyms, df_related_synonyms) %>%
{ data.frame(lapply( . , trimws), stringsAsFactors = FALSE) } %>% #trim any whitespace 
{ data.frame(lapply( . , tolower), stringsAsFactors = FALSE) }

df_BCO_labels$label <- gsub("_", " ", df_BCO_labels$label) %>% # replace '_' with a space
  { gsub("'", "", . ) } # remove single quotes

df_BCO_labels <- df_BCO_labels %>%
	filter (label != '') %>%
	distinct() %>%
	arrange(label) # sort alphabetically


##### Get labels from PCO

# Read in csv file
df_PCO <- read.csv(file = paste0(subDir,'/', 'pco_all_labels_and_IDs.csv')) 

# Put all of the labels into a single column
df_labels <-  df_PCO %>% 
	select (label, ID) %>%
	{ filter( . , label != "" ) } # remove rows that don't have labels

df_altLabels <- df_PCO %>%
	dplyr::select (label = altLabel, ID)

df_prefLabels <- df_PCO %>%
	dplyr::select (label = prefLabel, ID)

df_hiddenLabels <- df_PCO %>%
	dplyr::select (label = hiddenLabel, ID)

df_IAO_0000118 <- df_PCO %>%
	dplyr::select (label = IAO_0000118, ID)

df_BCO_0000060 <- df_PCO %>%
	dplyr::select (label = BCO_0000060, ID)

df_exact_synonyms <- df_PCO %>%
	dplyr::select (label = exact_synonym, ID)

df_related_synonyms <- df_PCO %>%
	dplyr::select (label = related_synonym, ID)


df_PCO_labels <- rbind(df_labels, df_prefLabels, df_altLabels, df_hiddenLabels, df_IAO_0000118, df_BCO_0000060, df_exact_synonyms, df_related_synonyms) %>%
{ data.frame(lapply( . , trimws), stringsAsFactors = FALSE) } %>% #trim any whitespace 
{ data.frame(lapply( . , tolower), stringsAsFactors = FALSE) }

df_PCO_labels$label <- gsub("_", " ", df_PCO_labels$label) %>% # replace '_' with a space
  { gsub("'", "", .) }# remove single quotes

df_PCO_labels <- df_PCO_labels %>%
	filter (label != '') %>%
	distinct() %>%
	arrange(label) # sort alphabetically

##### Get labels from PATO

# Read in csv file
df_PATO <- read.csv(file = paste0(subDir,'/', 'pato_all_labels_and_IDs.csv')) 

# Put all of the labels into a single column
df_labels <-  df_PATO %>% 
	select (label, ID) %>%
	{ filter( . , label != "" ) } # remove rows that don't have labels

df_altLabels <- df_PATO %>%
	dplyr::select (label = altLabel, ID)

df_prefLabels <- df_PATO %>%
	dplyr::select (label = prefLabel, ID)

df_hiddenLabels <- df_PATO %>%
	dplyr::select (label = hiddenLabel, ID)

df_IAO_0000118 <- df_PATO %>%
	dplyr::select (label = IAO_0000118, ID)

df_BCO_0000060 <- df_PATO %>%
	dplyr::select (label = BCO_0000060, ID)

df_exact_synonyms <- df_PATO %>%
	dplyr::select (label = exact_synonym, ID)

df_related_synonyms <- df_PATO %>%
	dplyr::select (label = related_synonym, ID)


df_PATO_labels <- rbind(df_labels, df_prefLabels, df_altLabels, df_hiddenLabels, df_IAO_0000118, df_BCO_0000060, df_exact_synonyms, df_related_synonyms) %>%
{ data.frame(lapply( . , trimws), stringsAsFactors = FALSE) } %>% #trim any whitespace 
{ data.frame(lapply( . , tolower), stringsAsFactors = FALSE) }

df_PATO_labels$label <- gsub("_", " ", df_PATO_labels$label) %>% # replace '_' with a space
  { gsub("'", "", . ) }# remove single quotes

df_PATO_labels <- df_PATO_labels %>%
	filter (label != '') %>%
	distinct() %>%
	arrange(label) # sort alphabetically


##### Get labels from ENVO

# Read in csv file
df_ENVO <- read.csv(file = paste0(subDir,'/', 'envo_all_labels_and_IDs.csv')) 

# Put all of the labels into a single column
df_labels <-  df_ENVO %>% 
	select (label, ID) %>%
	{ filter( . , label != "" ) } # remove rows that don't have labels

df_altLabels <- df_ENVO %>%
	dplyr::select (label = altLabel, ID)

df_prefLabels <- df_ENVO %>%
	dplyr::select (label = prefLabel, ID)

df_hiddenLabels <- df_ENVO %>%
	dplyr::select (label = hiddenLabel, ID)

df_IAO_0000118 <- df_ENVO %>%
	dplyr::select (label = IAO_0000118, ID)

df_BCO_0000060 <- df_ENVO %>%
	dplyr::select (label = BCO_0000060, ID)

df_exact_synonyms <- df_ENVO %>%
	dplyr::select (label = exact_synonym, ID)

df_related_synonyms <- df_ENVO %>%
	dplyr::select (label = related_synonym, ID)


df_ENVO_labels <- rbind(df_labels, df_prefLabels, df_altLabels, df_hiddenLabels, df_IAO_0000118, df_BCO_0000060, df_exact_synonyms, df_related_synonyms) %>%
{ data.frame(lapply( . , trimws), stringsAsFactors = FALSE) } %>% #trim any whitespace 
{ data.frame(lapply( . , tolower), stringsAsFactors = FALSE) }

df_ENVO_labels$label <- gsub("_", " ", df_ENVO_labels$label) %>% # replace '_' with a space
{ gsub("'", "", . ) }# remove single quotes

df_ENVO_labels <- df_ENVO_labels %>%
	filter (label != '') %>%
	distinct() %>%
	arrange(label) # sort alphabetically

##### Get labels from CHEBI

# Read in csv file
df_CHEBI <- read.csv(file = paste0(subDir,'/', 'chebi_all_labels_and_IDs.csv')) 

# Put all of the labels into a single column
df_labels <-  df_CHEBI %>% 
	select (label, ID) %>%
	{ filter( . , label != "" ) } # remove rows that don't have labels

df_altLabels <- df_CHEBI %>%
	dplyr::select (label = altLabel, ID)

df_prefLabels <- df_CHEBI %>%
	dplyr::select (label = prefLabel, ID)

df_hiddenLabels <- df_CHEBI %>%
	dplyr::select (label = hiddenLabel, ID)

df_IAO_0000118 <- df_CHEBI %>%
	dplyr::select (label = IAO_0000118, ID)

df_BCO_0000060 <- df_CHEBI %>%
	dplyr::select (label = BCO_0000060, ID)

df_exact_synonyms <- df_CHEBI %>%
	dplyr::select (label = exact_synonym, ID)

df_related_synonyms <- df_CHEBI %>%
	dplyr::select (label = related_synonym, ID)


df_CHEBI_labels <- rbind(df_labels, df_prefLabels, df_altLabels, df_hiddenLabels, df_IAO_0000118, df_BCO_0000060, df_exact_synonyms, df_related_synonyms) %>%
{ data.frame(lapply( . , trimws), stringsAsFactors = FALSE) } %>% #trim any whitespace 
{ data.frame(lapply( . , tolower), stringsAsFactors = FALSE) }

df_CHEBI_labels$label <- gsub("_", " ", df_CHEBI_labels$label) %>% # replace '_' with a space
{ gsub("'", "", . ) }# remove single quotes

df_CHEBI_labels <- df_CHEBI_labels %>%
	filter (label != '') %>%
	distinct() %>%
	arrange(label) # sort alphabetically


# Read in Envthes labels
df_Envthes_labels <- read.csv(paste0(subDir, "/envthes_all_labels_and_IDs.csv"), stringsAsFactors = FALSE)


### Combine all labels
df_all_labels <- rbind(df_ENVO_labels, df_ECSO_labels, df_Envthes_labels, df_BCO_labels, df_PCO_labels, df_PATO_labels, df_CHEBI_labels) %>%
	filter (label != '') %>%
	select (label) %>%
	distinct() %>%
	arrange(label) # sort alphabetically


# Create duplicate label columns to preserve labels after joining
df_ENVO_labels$ENVO_labels <- df_ENVO_labels$label 
df_Envthes_labels$Envthes_labels <- df_Envthes_labels$label 
df_ECSO_labels$ECSO_labels <- df_ECSO_labels$label
df_PCO_labels$PCO_labels <- df_PCO_labels$label
df_BCO_labels$BCO_labels <- df_BCO_labels$label
df_PATO_labels$PATO_labels <- df_PATO_labels$label
df_CHEBI_labels$CHEBI_labels <- df_CHEBI_labels$label


# Join the columns into a single table
df_final <- full_join(df_all_labels, df_ECSO_labels) %>%
	dplyr::rename(., "ECSO_ID" = "ID")

df_final <- full_join(df_final, df_Envthes_labels) %>%
	dplyr::rename(., "Envthes_ID" = "ID")

df_final <- full_join(df_final, df_ENVO_labels) %>%
	dplyr::rename(., "ENVO_ID" = "ID")

df_final <- full_join(df_final, df_PATO_labels) %>%
	dplyr::rename(., "PATO_ID" = "ID")

df_final <- full_join(df_final, df_PCO_labels) %>%
	dplyr::rename(., "PCO_ID" = "ID")

df_final <- full_join(df_final, df_BCO_labels) %>%
	dplyr::rename(., "BCO_ID" = "ID")

df_final <- full_join(df_final, df_CHEBI_labels) %>%
	dplyr::rename(., "CHEBI_ID" = "ID")


# Remove NA's
df_final[is.na(df_final)] <- ""


# Write CSV file
write.csv(df_final, file = paste0(outputDir,"/all_ontologies_with_IDs.csv"), row.names = FALSE)


