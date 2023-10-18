# Group B Streptococcus (GBS) identification and typing   

## Introduction  

This workflow will identify and serotype group B Streptococcus.  
This is a bioinformatic pipeline developed using WDL to perform serotyping group B Streptococcus speices. This pipeline uses docker containers which will simplyfy and reduce the installation and compatibility issues arrise duing installation of softwares. The workflow can be deployed in a standalone computer as well as using Terra platform. To run as a standalone simply clone the repository to your working environment. To run the pipeline you need a cromwell to be installed as a prerequisite. To run in Terra platform, you can use the [Dockstore](https://dockstore.org/workflows/github.com/neranjan007/GBS_Identification_and_Typing/GBS_Identification_and_Typing:main?tab=info) to search and launch to Terra.   

CT-GBSIDnType workflow takes paired end reads as input, and will perform:  
*  Quality control
*  Contamination check
*  Assemble reads to scaffolds
*  Confirm taxa
*  Perform sequence typing (GBS)
*  Check for antibiotic resistance genes  


Reference   
*   Tiruvayipati, et al. "GBS-SBG - GBS Serotyping by Genome Sequencing." Microb Genom. 2021 Dec;7(12). doi: 10.1099/mgen.0.000688
*   
