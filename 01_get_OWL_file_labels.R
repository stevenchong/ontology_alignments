### This script tabularizes the label and definition fields in an OWL file that is in RDF/XML format.  It will create a CSV file
### with columns containing the class URIs, labels, preferred labels, alternative labels, hidden labels, and definitions for each
### OWL file in the input folder.

#Libraries
library(dplyr)
library(xml2)
library(tidyr)


### Read input subdirectory and create output subdirectory
input_subDir <- "./01_input_files"

output_subDir <- "./02_output_labels_files"

dir.create(file.path(getwd(), output_subDir), showWarnings = FALSE)


#Read in list of OWL files
ontology_file_list <- list.files(path = input_subDir, full.names = TRUE, pattern = ".owl", ignore.case = TRUE)

### Process OWL files
for (i in 1:length(ontology_file_list)) {
	
	list_IDs <- list()
	
	df_length <- 1
	
	#Get ontology file name
	ontology_name <- basename(ontology_file_list[i]) %>%
	{	gsub(".owl", "", .) }
	
	
	#Read in ontology file as XML
	ontology_file <- read_xml(ontology_file_list[i])


	# Get the all of the ontology terms
	IDs <- xml_find_all(ontology_file, "//owl:Class[@rdf:about]") #%>%
	
	# Temporarily suppress warnings
	oldw <- getOption("warn")
	options(warn = -1)
	
	# Iterate through each term 
	for (counter in 1:length(IDs)){
		
		
		# Extract the ID, labels, and definition for each term
		
		ID 										<- xml_attrs(IDs[counter])
		label 								<- as.character(xml_find_all(IDs[counter], "rdfs:label/text()"))
		prefLabel 						<- as.character(xml_find_all(IDs[counter], "skos-owl1-dl:prefLabel/text()") )
		altLabel 							<- as.character(xml_find_all(IDs[counter], "skos-owl1-dl:altLabel/text()") )
		hiddenLabel 					<- as.character(xml_find_all(IDs[counter], "skos-owl1-dl:hiddenLabel/text()") )
		IAO_0000118 					<- as.character(xml_find_all(IDs[counter], "obo:IAO_0000118/text()") )
		exact_synonym 				<- as.character(xml_find_all(IDs[counter], "oboInOwl:hasExactSynonym/text()") )
		BCO_0000060 					<- as.character(xml_find_all(IDs[counter], "obo:BCO_0000060/text()") )
		related_synonym				<- as.character(xml_find_all(IDs[counter], "oboInOwl:hasRelatedSynonym/text()") )
		
		#Collapse multiple exact synonyms into a single character vector (will be split later)
		exact_synonym <- paste(exact_synonym, collapse = "|", sep = "")
		
		#Collapse multiple related synonyms into a single character vector (will be split later)
		related_synonym	<- paste(related_synonym, collapse = "|", sep = "")		
		
		
		# Set the lengths of the individual dataframes
		if (length(prefLabel) > length(altLabel) ){
			df_length <- length(prefLabel)
		} else {
			df_length <- length(altLabel)
		}
		
		if(length(hiddenLabel) > df_length){
			df_length <- length(hiddenLabel)
		}
		
		if(length(label) > df_length){
			df_length <- length(label)
		}
		
		if(length(IAO_0000118) > df_length){
			df_length <- length(IAO_0000118)
		}
		
		
		if(length(exact_synonym) > df_length){
			df_length <- length(exact_synonym)
		}
		
		if(length(BCO_0000060) > df_length){
			df_length <- length(BCO_0000060)
		}
		
		if(length(related_synonym) > df_length){
			df_length <- length(related_synonym)
		}
		
		# If all the fields are empty, make the dataframe the length of the ID
		if (length(altLabel) == 0 && length(prefLabel) == 0 && length(label) == 0 && length(hiddenLabel) == 0 && length(IAO_0000118) == 0 
				&& length(exact_synonym) == 0 && length(BCO_0000060) == 0 && length(related_synonym) == 0) {
			
			df_length <- length(ID)
		}
		
		
		
		#Make the dataframe
		df_individual_term <- as.data.frame(matrix(nrow = df_length, dimnames = list(c(),c("ID"))), stringsAsFactors = FALSE)
		
		# Set blanks if no text in any of the fields
		if (length(label) == 0 ){
			label <- ""
		}
		
		
		if(length(altLabel) == 0){
			altLabel <- ""
		}
		
		if(length(prefLabel) == 0){
			prefLabel <- ""
		}
		
		if(length(hiddenLabel) == 0){
			hiddenLabel <- ""
		}
		
		if(length(IAO_0000118) == 0){
			IAO_0000118 <- ""
		}
	
		
		if(length(exact_synonym) == 0){
			exact_synonym <- ""
		}
		
		if(length(BCO_0000060) == 0){
			BCO_0000060 <- ""
		}
		
		if(length(related_synonym) == 0){
			related_synonym <- ""
		}
		
		# Assemble the dataframes for individual terms
		df_individual_term$ID <- as.character(ID)
		
		df_individual_term$label <- label %>%
			trimws()
		
		df_individual_term$prefLabel <- prefLabel %>%
			trimws()
		
		df_individual_term$altLabel <- altLabel %>%
			trimws()
		
		df_individual_term$hiddenLabel <- hiddenLabel %>%
			trimws()
		
		df_individual_term$IAO_0000118 <- IAO_0000118 %>%
			trimws()
		
		
		df_individual_term$BCO_0000060 <- BCO_0000060 %>%
			trimws()
		
		
		df_individual_term$exact_synonym <- exact_synonym %>%
			trimws()
		
		df_individual_term$related_synonym <- related_synonym %>%
			trimws()
		
		
		list_IDs[[counter]] <- df_individual_term
		
	}
	
	# End suppression of warnings
	options(warn = oldw) 
	
	
	# Combine the individual dataframes
	df_all_terms <- do.call(bind_rows, list_IDs) %>%
		distinct()
	
	# Split the cells containing the '|' separator in the synonyms
	df_split_synonyms <- df_all_terms %>%
		mutate(exact_synonym = strsplit(exact_synonym, "\\|")) %>%  # split the exact synonyms 
		unnest(exact_synonym) %>%
		mutate(related_synonym = strsplit(related_synonym, "\\|")) %>%  # split the related synonyms
		unnest(related_synonym)
	
	# Combine the split synonyms dataframe with the rest of the terms and filter out any rows containing '|'
	df_all_labels <- rbind(df_all_terms, df_split_synonyms) %>%
		filter(!grepl("\\|",exact_synonym)) %>%
		filter(!grepl("\\|",related_synonym)) %>%
		distinct()
	
	# Create output CSV file
	write.csv(df_all_labels, file = paste0(output_subDir,"/", ontology_name, "_", "all_labels_and_IDs.csv"), row.names = FALSE)
	
}
