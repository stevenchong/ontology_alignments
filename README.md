# Comparison of ECSO, ENVO, EnvThes and other vocabulary terms

This directory contains scripts and input files to compare the labels (including preferred, hidden and alternative labels) in ECSO, ENVO, EnvThes, PCO, BCO, PATO, and CHEBI. 

## Steps
1. Download this directory and open the ECSO_ENVO_Envthes.Rproj file with RStudio.
2. Run the first script (`01_get_OWL_file_labels.R`). This script:
   * reads in the OWL files in the '01_input_files folder'
   * creates a '02_output_labels_files' subfolder
   * creates CSV files that lists labels, IDs and synonyms for each vocabulary

3. Run the second script (`02_get_RDF_file_labels.R`). This script:
   * reads in the RDF files in the '01_input_files folder'
   * creates CSV files that list the labels (in a single column) and the IDs for the labels
   
4. Run the third script (`03_vocabulary_comparisons.R`) This script:
   * creates the '03_comparison_tables' subfolder
   * reads in the label and ID CSV files created in steps 2 and 3
   * creates the all_ontologies_with_IDs.csv file.  This file shows you how the vocabularies overlap and where the label terms originated from. The labels from each of the vocabularies are combined into a single column and aligned with the terms from the individual vocabularies and IDs. Label names are duplicated if the same string is assigned to multiple IDs/URIs. The alignment is based on label matches. 
   * Note that underscores, hyphens, and single quotes in label names are removed and only unique terms from each ontology are displayed
   * Also note that the `chebi.owl` file may be downloaded from here: http://purl.obolibrary.org/obo/chebi.owl (the file is too large to place in this repo). Be aware that extracting the CHEBI labels takes a _long_ time (nearly 3 days on the author's computer). You may want to comment out the lines in the `03_vocabulary_comparisons.R` script that compare the CHEBI labels until after you process the CHEBI file.
   
   
 Note: You will see the message ```xmlXPathEval: evaluation failed``` in your RStudio console. Don't worry, as this is caused by a known [issue] with the `libxml2` library and the scripts should process the files as expected.  
 
 [issue]: https://github.com/r-lib/xml2/issues/209
