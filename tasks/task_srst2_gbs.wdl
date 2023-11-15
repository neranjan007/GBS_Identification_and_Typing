version 1.0

task srst2_gbs_task{
    meta{
        description: "Short Read Sequence Typing for Bacterial Pathogens : GBS"
    }

    input{
        #task inputs
        File read1
        File read2
        Boolean terra = false
        Int cpu = 2
        String docker = "neranjan007/srst2:0.2.0-gbs"
        Int memory = 100
        String samplename
    }

    command <<<
        if [[ "~{terra}" == "true" ]]; then
            INPUT_READS="--input_pe ~{read1} ~{read2} --forward _R1 --reverse _R2"
            echo "  ${INPUT_READS} "
            echo " terra is true"
        else
            INPUT_READS="--input_pe ~{read1} ~{read2}"
            echo " ${INPUT_READS} "
            echo " terra is false"
        fi

        srst2 ${INPUT_READS} --output ~{samplename}-serotypes --log --gene_db /gbs-db/GBS-SBG.fasta

        if [ -f  "~{samplename}-serotypes__genes__GBS-SBG__results.txt" ]; then
            awk -F "\t" 'NR==2 {print $2}' ~{samplename}-serotypes__genes__GBS-SBG__results.txt > SEROTYPE
        else
            echo "No serotype detected" > SEROTYPE
            echo "No serotype detected" > ~{samplename}-serotypes__genes__GBS-SBG__results.txt
        fi 

        if [ -f "~{samplename}-serotypes__fullgenes__GBS-SBG__results.txt" ]; then 
            echo "fullgenes__GBS-SBG__results.txt file exsits"
        else
            echo "fullgenes__GBS-SBG__results.txt file not present"
            echo "No fullgenes file produced" > ~{samplename}-serotypes__fullgenes__GBS-SBG__results.txt
        fi

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
