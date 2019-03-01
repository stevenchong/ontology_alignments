### This script tabularizes the label and definition fields in an RDF file that is in RDF/XML format.  It will create a CSV file
### with columns containing the class URIs, labels, preferred labels, alternative labels, hidden labels, and definitions
### for each RDF file in the input folder. 

### Libraries
library(dplyr)
library(xml2)
library(readxl)


### Functions
# Reads in the XML from a SKOS ontology file and creates a dataframe containingcolumns for concept IDs, preferred labels and alternative labels
get_concept_labels <- function (concepts) {
	
	# Initialize list
	list_concepts <- list()
	
	for (counter in 1:length(concepts)){ 
		
		# Get the text for each concept ID, prefLabel and altLabel 
		ID <- xml_attrs(concepts[counter])
		prefLabel <- as.character(xml_find_all(concepts[counter], "skos:prefLabel[@xml:lang='en']/text()") )
		altLabel <- as.character(xml_find_all(concepts[counter], "./skos:altLabel[@xml:lang='en']/text()") )
		
		# Use the longest length to set the dataframe for each concept
		if (length(prefLabel) > length(altLabel) ){
			df_length <- length(prefLabel)
		} else {
			df_length <- length(altLabel)
		}
		
		# If there are no altLabels or prefLabels
		if (length(altLabel) == 0 && length(prefLabel) == 0){
			df_length <- length(ID)
		}
		
		# Make the dataframe
		df_individual_concept <- as.data.frame(matrix(nrow = df_length, dimnames = list(c(),c("ID"))), stringsAsFactors = FALSE)
		
		# Set blanks if no text for any of the labels
		if(length(altLabel) == 0){
			altLabel <- ""
		}
		
		if(length(prefLabel) == 0){
			prefLabel <- ""
		}
		
		# Insert the text into the dataframe
		df_individual_concept$ID <- as.character(ID)
		df_individual_concept$skos_prefLabel <- prefLabel %>%
			trimws() %>%
			{ gsub('[\r\n]', "", .) } %>%
			{ gsub('  ', "", .) }
			
		df_individual_concept$skos_altLabel <- altLabel %>%
			trimws() %>%
			{ gsub('[\r\n]', "", .) } %>%
			{ gsub('  ', "", .) }
		
		# Insert each dataframe into the list
		list_concepts[[counter]] <- df_individual_concept
		
	}
	
	# Combine the dataframes, remove duplicate rows
	df_all_concepts <- do.call(bind_rows, list_concepts) %>%
		distinct() 
	
}


# Reads in dataframe containing preferred and alternative labels and combines them into a single column
get_labels <- function(df_all_concepts) {

	altLabels <- data.frame(df_all_concepts$skos_altLabel, df_all_concepts$ID) %>% 
		select(label = df_all_concepts.skos_altLabel, ID = df_all_concepts.ID)
	
	prefLabels <- data.frame(df_all_concepts$skos_prefLabel, df_all_concepts$ID) %>% 
		select(label = df_all_concepts.skos_prefLabel, ID = df_all_concepts.ID)
	
	labels <- rbind(prefLabels, altLabels) %>%
	{ data.frame(lapply( . , trimws), stringsAsFactors = FALSE) } %>% #trim any whitespace 
	{ data.frame(lapply( . , tolower), stringsAsFactors = FALSE) } %>%
		filter (label != '') %>%
		distinct() %>%
		arrange(label) # sort alphabetically

}

### Read input subdirectory and create output subdirectory
input_subDir <- "./01_input_files"

output_subDir <- "./02_output_labels_files"

dir.create(file.path(getwd(), output_subDir), showWarnings = FALSE)


##### Get labels

#Read in list of RDF files
ontology_file_list <- list.files(path = input_subDir, full.names = TRUE, pattern = ".rdf", ignore.case = TRUE)

for (i in 1:length(ontology_file_list)) {

	#Get ontology file name
	ontology_name <- basename(ontology_file_list[i]) %>%
	{	gsub(".rdf", "", .) }
	
	#Read in ontology file as XML
	ontology_file <- read_xml(ontology_file_list[i])
	
	# Find all concept nodes
	concepts <- xml_find_all(ontology_file, "rdf:Description")


	# Create dataframe storing all concepts and their labels
	df_all_concepts <- get_concept_labels(concepts)

	# Put all labels into a single column
	df_labels <- get_labels(df_all_concepts)

	# Write CSV (all labels in a single column)
	write.csv(df_labels, file = paste0(output_subDir,"/", ontology_name, "_all_labels_and_IDs.csv"), row.names = FALSE)

}
