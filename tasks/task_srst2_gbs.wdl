version 1.0

task srst2_gbs_task{
    meta{
        description: "Short Read Sequence Typing for Bacterial Pathogens : GBS"
    }

    input{
        #task inputs
        File read1
        File read2
        Int cpu = 2
        String docker = "neranjan007/srst2:0.2.0-gbs"
        Int memory = 100
        String samplename
    }

    command <<<
    
        srst2 --input_pe ~{read1} ~{read2} --output ~{samplename}-serotypes --log --gene_db /gbs-db/GBS-SBG.fasta

        awk -F "\t" 'NR==2 {print $2}' ~{samplename}-serotypes__genes__GBS-SBG__results.txt > SEROTYPE
    >>>

    output{
        File srst2_gbs_report = "~{samplename}-serotypes__genes__GBS-SBG__results.txt"
        File srst2_gbs_fullgenes_report = "~{samplename}-serotypes__fullgenes__GBS-SBG__results.txt"
        String srst2_gbs_serotype = read_string("SEROTYPE")
    }

    runtime {
        docker: "~{docker}"
        memory: "~{memory} GB"
        cpu: cpu
        disks: "local-disk 100 SSD"
        preemptible: 0
    }

}