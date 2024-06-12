version 1.0

task blast_virulence_task{
    meta{
        description: "blast strep_agalactiae virulence genes of VFDB"
    }    

    input{
        String samplename
        File sample_file
        File db_fasta_file
        Float evalue = 0.000001
        Int max_hsps = 1
        Float percent_identity = 90.0
        String docker = "staphb/blast:2.15.0"
        Int cpu = 1
        Int memory = 2
    } 

    command <<<
        # version
        blastn -version | grep blastn | cut -d " " -f2 > version

        # blastn
        blastn -subject ~{db_fasta_file} -query ~{sample_file} -evalue ~{evalue} -max_hsps ~{max_hsps} -outfmt 6 -out blast_out.txt

        for a in $(awk ' {print $2}' blast_out.txt);
        do
            grep $a ~{db_fasta_file} >> gene_names.txt
        done 

        paste blast_out.txt gene_names.txt > blast_out_wt_gene_names.txt

        awk 'BEGIN{print "qseqid\tsseqid\tpident\tlength\tmismatch\tgapopen\tqstart\tqend\tsstart\tsend\tevalue\tbitscore\tgidgname\tgname\tgdiscription\tgvirfactor\tgfunction"}; {print}' blast_out_wt_gene_names.txt > ~{samplename}-blast_out_wt_gene_names.txt

        awk 'BEGIN{print "qseqid\tsseqid\tpident\tlength\tmismatch\tgapopen\tqstart\tqend\tsstart\tsend\tevalue\tbitscore\tgidgname\tgname\tgdiscription\tgvirfactor\tgfunction"};{ if($3>=~{percent_identity}) {print}}' blast_out_wt_gene_names.txt > ~{samplename}-filtered-blast_out_wt_gene_names.txt
        
        hits=$(awk '{print $14}' blast_out_wt_gene_names.txt | tr '\n' ', ' | sed 's/.$//')

        filtered_hits=$(awk '{if($3>=~{percent_identity}) {print $14}}' blast_out_wt_gene_names.txt | tr '\n' ', ' | sed 's/.$//')

        awk '{print $14}' blast_out_wt_gene_names.txt | sort | uniq -c > ~{samplename}-blast_out_wt_gene_names_uniq_list.txt

        if [ -z "$filtered_hits"]
        then
            echo "No blast hit!" > BLAST_FILTERED_HITS 
        else
            echo $filtered_hits > BLAST_FILTERED_HITS
        fi 

    >>>

    output{
        File blast_file = "~{samplename}-blast_out_wt_gene_names.txt"
        File blast_file_filtered = "~{samplename}-filtered-blast_out_wt_gene_names.txt"
        File blast_uniq_gene_list = "~{samplename}-blast_out_wt_gene_names_uniq_list.txt"
        String blast_filtered_hits = read_string("BLAST_FILTERED_HITS")
    }

    runtime{
        docker: "~{docker}"
        memory: "~{memory} GB"
        cpu: cpu
        disks: "local-disk 50 SSD"
        preemptible: 0
    }
}
