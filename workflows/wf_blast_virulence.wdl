version 1.0

import "../tasks/task_blast_virulence.wdl" as blast_virulence

workflow blast_virulence_workflow{
    input{
        String samplename
        File sample_file
        File db_fasta_file
        Float? evalue = 0.000001
        Int? max_hsps = 1
        Float? percent_identity = 90.0
    }

    # blast virulence
    call blast_virulence.blast_virulence_task{
        input:
            samplename = samplename,
            sample_file = sample_file,
            db_fasta_file = db_fasta_file,
            evalue = evalue,
            max_hsps = max_hsps,
            percent_identity = percent_identity
    }

    output{
        # blast virulence
        File blast_output = blast_virulence_task.blast_file
        File blast_filtered_output = blast_virulence_task.blast_file_filtered
        File blast_uniq_gene_list = blast_virulence_task.blast_uniq_gene_list
        String blast_filtered_hits = blast_virulence_task.blast_filtered_hits
    }
}