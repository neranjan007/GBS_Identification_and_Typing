# Group B Streptococcus (GBS) identification and typing   

## Introduction  

This workflow will identify and serotype group B Streptococcus.  
This is a bioinformatic pipeline developed using WDL to perform serotyping group B Streptococcus speices. This pipeline uses docker containers which will simplyfy and reduce the installation and compatibility issues arrise duing installation of softwares. The workflow can be deployed in a standalone computer as well as using Terra platform. To run as a standalone simply clone the repository to your working environment and to run the pipeline you need a cromwell to be installed as a prerequisite. To run in Terra platform, you can use the [Dockstore](https://dockstore.org/workflows/github.com/neranjan007/GBS_Identification_and_Typing/GBS_Identification_and_Typing:main?tab=info) to search and launch to Terra.   

CT-GBSIDnType workflow takes paired end reads as input, and will perform:  
*  Quality control
*  Contamination check
*  Assemble reads to scaffolds
*  Confirm taxa
*  Perform sequence typing (GBS)  
*  Check for surface genes (Pili, Alpha like proteins, Serine rich proteins)
*  Check for antibiotic resistance genes  

## Quick Run Guide  
Pipeline can be run on command line or using Terra interface.  

### Database:   
Will need the Kraken2/Bracken database present as a tar.gz file.   
[Standard-8](https://genome-idx.s3.amazonaws.com/kraken/k2_standard_08gb_20230605.tar.gz) :  [https://benlangmead.github.io/aws-indexes/k2](https://benlangmead.github.io/aws-indexes/k2)   


### command line  
Pre-requisite: Cromwell need to be installed in the local computer.  

Input JSON file should have the following required input variables:  
```json
{
  "GBS_identification_n_typing_workflow.samplename": "String",
  "GBS_identification_n_typing_workflow.R1": "File",
  "GBS_identification_n_typing_workflow.R2": "File",
  "GBS_identification_n_typing_workflow.kraken2_database": "File"
} 
```



## Reference   
*   Tiruvayipati, et al. "GBS-SBG - GBS Serotyping by Genome Sequencing." Microb Genom. 2021 Dec;7(12). doi: 10.1099/mgen.0.000688
*   Metcalf BJ, Chochua S, Gertz RE, Hawkins PA, Ricaldi J, et al. Short-read whole genome sequencing for determination of antimicrobial resistance mechanisms and capsular serotypes of current invasive Streptococcus agalactiae recovered in the USA. Clin Microbiol Infect. 2017;23:574. doi: 10.1016/j.cmi.2017.02.021  
*   Sheppard AE, Vaughan A, Jones N, Turner P, Turner C. Capsular typing method for Streptococcus agalactiae using whole-genome sequence data. J Clin Microbiol. 2016;54:1388–1390. doi: 10.1128/JCM.03142-15   
*   Kapatai G, Patel D, Efstratiou A, Chalker VJ. Comparison of molecular serotyping approaches of Streptococcus agalactiae from genomic sequences. BMC Genomics. 2017;18:429. doi: 10.1186/s12864-017-3820-5   
