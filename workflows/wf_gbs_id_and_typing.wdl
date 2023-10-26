version 1.0

import "../tasks/task_fastqc.wdl" as fastqc
import "../tasks/task_kraken_n_bracken.wdl" as kraken_n_bracken
import "../tasks/task_srst2_gbs.wdl" as srst2_gbs
import "../tasks/task_trimmomatic.wdl" as trimmomatic
import "../tasks/task_spades.wdl" as spades
import "../tasks/task_quast.wdl" as quast
import "../tasks/task_rmlst.wdl" as rmlst
import "../tasks/task_gbs_sbg.wdl" as gbs_sbg
import "../tasks/task_mummer-ani.wdl" as ani
import "../tasks/task_ts_mlst.wdl" as ts_mlst
import "../tasks/task_amrfinderplus.wdl" as amrfinderplus
import "../tasks/task_blast.wdl" as blast

workflow GBS_identification_n_typing_workflow{
    input{
        File R1
        File R2
        String samplename
        String? emmtypingtool_docker_image
        File? referance_genome
        File vfdb # http://www.mgc.ac.cn/VFs/download.htm
        File kraken2_db
    }

    # tasks and/or subworkflows to execute
    call fastqc.fastqc_task as rawfastqc_task{
        input:
            read1 = R1,
            read2 = R2 
    }

    call trimmomatic.trimmomatic_task{
        input:
            read1 = R1,
            read2 = R2
    }

    call fastqc.fastqc_task as trimmedfastqc_task{
        input:
            read1 = trimmomatic_task.read1_paired,
            read2 = trimmomatic_task.read2_paired
    }

    call kraken_n_bracken.kraken_n_bracken_task as trimmed_kraken_n_bracken_task{
        input:
            read1 = trimmomatic_task.read1_paired,
            read2 = trimmomatic_task.read2_paired,
            samplename = samplename,
            kraken2_db = kraken2_db
    }

    call srst2_gbs.srst2_gbs_task{
        input:
            read1 = trimmomatic_task.read1_paired,
            read2 = trimmomatic_task.read2_paired,
            samplename = samplename
    }

    call spades.spades_task{
        input:
            read1 = trimmomatic_task.read1_paired,
            read2 = trimmomatic_task.read2_paired,
            samplename = samplename
    }

    call quast.quast_task{
        input:
            assembly = spades_task.scaffolds,
            samplename = samplename
    }

    call rmlst.rmlst_task{
        input:
            scaffolds = spades_task.scaffolds
    }

    call gbs_sbg.gbs_sbg_task{
        input:
            assembly = spades_task.scaffolds,
            samplename = samplename
    }

    call ani.mummerANI_task{
        input:
            assembly = spades_task.scaffolds,
            ref_genome = referance_genome,
            samplename = samplename
    }

    call ts_mlst.ts_mlst_task{
        input:
            assembly = spades_task.scaffolds,
            samplename = samplename
    }

    call amrfinderplus.amrfinderplus_task{
        input:
            assembly = spades_task.scaffolds,
            samplename = samplename,
            organism = trimmed_kraken_n_bracken_task.bracken_taxon
    }

    if ( vfdb != 'null') {
        call blast.tblastn as virulance {
            input:
                samplename = samplename,
                vfdb = vfdb,
                subject = spades_task.scaffolds
        }
    }

    output{
        # raw fastqc
        File FASTQC_raw_R1 = rawfastqc_task.r1_fastqc
        File FASTQC_raw_R2 = rawfastqc_task.r2_fastqc
        String FASTQ_SCAN_raw_total_no_bases = rawfastqc_task.total_no_bases
        String FASTQ_SCAN_raw_coverage = rawfastqc_task.coverage
        String FASTQC_SCAN_exp_length = rawfastqc_task.exp_length

        # Trimmed read qc
        File FASTQC_Trim_R1 = trimmedfastqc_task.r1_fastqc
        File FASTQC_Trim_R2 = trimmedfastqc_task.r2_fastqc
        String FASTQ_SCAN_trim_total_no_bases = trimmedfastqc_task.total_no_bases
        String FASTQ_SCAN_trim_coverage = trimmedfastqc_task.coverage

        # kraken2 Bracken after trimming
        String Bracken_top_taxon = trimmed_kraken_n_bracken_task.bracken_taxon
        Int Bracken_taxid = trimmed_kraken_n_bracken_task.bracken_taxid
        Float Bracken_taxon_ratio = trimmed_kraken_n_bracken_task.bracken_taxon_ratio
        String Bracken_top_genus = trimmed_kraken_n_bracken_task.bracken_genus
        File Bracken_report_sorted = trimmed_kraken_n_bracken_task.bracken_report_sorted
        File Bracken_report_filtered = trimmed_kraken_n_bracken_task.bracken_report_filtered

        # srst2_sbg serotyping  
        File SRST2_SBG_report = srst2_gbs_task.srst2_gbs_report
        File SRST2_SBG_fullgenes_report = srst2_gbs_task.srst2_gbs_fullgenes_report
        String SRST2_GBS_serotype = srst2_gbs_task.srst2_gbs_serotype

        # Spades
        File Spades_scaffolds = spades_task.scaffolds

        # quast
        File QUAST_report = quast_task.quast_report
        Int QUAST_genome_length = quast_task.genome_length
        Int QUAST_no_of_contigs = quast_task.number_contigs
        Int QUAST_n50_value = quast_task.n50_value
        Float QUAST_gc_percent = quast_task.gc_percent

        # rMLST 
        String rMLST_TAXON = rmlst_task.taxon
        
        # gbs_sbg 
        File GBS_SBG_report = gbs_sbg_task.gbs_sbg_report
        File GBS_SBG_best_report = gbs_sbg_task.gbs_sbg_best_report
        String GBS_SBG_serotype = gbs_sbg_task.gbs_sbg_serotype

        # ani
        Float ani_precent_aligned = mummerANI_task.ani_precent_aligned
        Float ani_percent = mummerANI_task.ani_ANI
        String ani_species = mummerANI_task.ani_species

        # TS_MLST typing
        File TS_MLST_results = ts_mlst_task.ts_mlst_results
        String TS_MLST_predicted_st = ts_mlst_task.ts_mlst_predicted_st
        String TS_MLST_pubmlst_scheme = ts_mlst_task.ts_mlst_pubmlst_scheme
        String TS_MLST_allelic_profile = ts_mlst_task.ts_mlst_allelic_profile
        File? TS_MLST_novel_alleles = ts_mlst_task.ts_mlst_novel_alleles

        # amrfinderplus 
        File AMRFINDERPLUS_all_report = amrfinderplus_task.amrfinderplus_all_report
        File AMRFINDERPLUS_amr_report = amrfinderplus_task.amrfinderplus_amr_report
        File AMRFINDERPLUS_stress_report = amrfinderplus_task.amrfinderplus_stress_report
        File AMRFINDERPLUS_virulence_report = amrfinderplus_task.amrfinderplus_virulence_report
        String AMRFINDERPLUS_amr_core_genes = amrfinderplus_task.amrfinderplus_amr_core_genes
        String AMRFINDERPLUS_amr_plus_genes = amrfinderplus_task.amrfinderplus_amr_plus_genes
        String AMRFINDERPLUS_stress_genes = amrfinderplus_task.amrfinderplus_stress_genes
        String AMRFINDERPLUS_virulence_genes = amrfinderplus_task.amrfinderplus_virulence_genes
        String AMRFINDERPLUS_amr_classes = amrfinderplus_task.amrfinderplus_amr_classes
        String AMRFINDERPLUS_amr_subclasses = amrfinderplus_task.amrfinderplus_amr_subclasses

        # virulance
        File? virulance_results = virulance.blast_results
        String? virulance_genes = virulance.genes
        String? blast_docker = virulance.blast_docker
        String? blast_version = virulance.blast_version
    }
}