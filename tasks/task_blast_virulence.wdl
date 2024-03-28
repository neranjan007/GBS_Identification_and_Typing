version 1.0

task blast_virulence_task{
    meta{
        description: "blast strep_agalactiae virulence genes of VFDB"
    }    

    input{
        File samplename
        File db_fasta_file
        Float evalue = 1e-6
        Int max_hsps = 1
        Int percent_identity = 90
        String docker = "staphb/blast:2.14.0"
        Int cpu = 1
        Int memory = 2
    } 

    command <<<
        # version
        blastn -version | grep blastn | cut -d " " -f2 > version

        # blastn
        blastn -subject ~{db_fasta_file} -query ~{samplename} -evalue ~{evalue} -max_hsps ~{max_hsps} -outfmt 6 -out blast_out.txt
        awk 'BEGIN{print "qseqid\tsseqid\tpident\tlength\tmismatch\tgapopen\tqstart\tqend\tsstart\tsend\tevalue\tbitscore"};$3>=~{percent_identity} {print}' ~{samplename}-blast_out.txt
        hits=$(awk '$3>=~{percent_identity} {print $2}' ~{samplename}-blast_out.txt | tr '\n' ', ' | sed 's/.$//')

        awk '$3>=~{percent_identity} {print $2}' blast_out.txt | grep -f - ~{db_fasta_file} > ~{samplename}-gene_discription.txt

        
    >>>

    output{
        File gene_discription_file = "~{samplename}-gene_discription.txt"
        File blast_file = "~{samplename}-blast_out.txt"
    }

    runtime{
        docker: "~{docker}"
        memory: "~{memory} GB"
        cpu: cpu
        disks: "local-disk 50 SSD"
        preemptible: 0
    }
}
