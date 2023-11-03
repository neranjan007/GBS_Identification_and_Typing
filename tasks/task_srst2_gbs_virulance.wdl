version 1.0

task srst2_gbs_virulence_task{
    meta{
        description: "Short Read Sequence virulence genes : GBS"
    }

    input{
        #task inputs
        File read1
        File read2
        Int cpu = 2
        String docker = "neranjan007/srst2:0.2.0-gbs-surfaceGenes"
        Int memory = 100
        String samplename
    }

    command <<<
    
        srst2 --input_pe ~{read1} ~{read2} --output ~{samplename}-virulence --log --gene_db /gbs-db/GBS_Surface_Genes.fasta

        # checks the output files of genes are present or not
        if [ -f  "~{samplename}-virulence__genes__GBS_Surface_Genes__results.txt" ]; then
            echo " virulence__genes__GBS_Surface_Genes__results.txt file present"
            # awk -F "\t" 'NR==2 {print $2}' ~{samplename}-virulence__genes__GBS_Surface_Genes__results.txt > SEROTYPE
        else
            # echo "No serotype detected" > SEROTYPE
            echo "No virulence genes detected" > ~{samplename}-serotypes__genes__GBS_Surface_Genes__results.txt
        fi 

        if [ -f "~{samplename}-virulence__fullgenes__GBS_Surface_Genes__results.txt" ]; then 
            echo "fullgenes__GBS_Surface_Genes__results.txt file exsits" 
            # grep each virulence gene
            # surface protein 
            awk ' /HVGA/ { print $4} ' ~{samplename}-virulence__fullgenes__GBS_Surface_Genes__results.txt > HVGA
            # pili
            awk ' /PI1 / { print $4 } ' ~{samplename}-virulence__fullgenes__GBS_Surface_Genes__results.txt > PI1
            awk ' /PI1B / { print $4 } ' ~{samplename}-virulence__fullgenes__GBS_Surface_Genes__results.txt > PI1B
            awk ' /PI2A1 / { print $4 } ' ~{samplename}-virulence__fullgenes__GBS_Surface_Genes__results.txt > PI2A1
            awk ' /PI2A2 / { print $4 } ' ~{samplename}-virulence__fullgenes__GBS_Surface_Genes__results.txt > PI2A2
            awk ' /PI2A3 / { print $4 } ' ~{samplename}-virulence__fullgenes__GBS_Surface_Genes__results.txt > PI2A3
            awk ' /PI2A4 / { print $4 } ' ~{samplename}-virulence__fullgenes__GBS_Surface_Genes__results.txt > PI2A4
            awk ' /PI2B / { print $4 } ' ~{samplename}-virulence__fullgenes__GBS_Surface_Genes__results.txt > PI2B
            awk ' /PI2B2 / { print $4 } ' ~{samplename}-virulence__fullgenes__GBS_Surface_Genes__results.txt > PI2B2
        else
            echo "fullgenes__GBS_Surface_Genes__results.txt file not present"
            echo "No fullgenes file produced" > ~{samplename}-virulence__fullgenes__GBS_Surface_Genes__results.txt
        fi

    >>>

    output{
        File srst2_gbs_virulence_report = "~{samplename}-virulence__genes__GBS_Surface_Genes__results.txt"
        File srst2_gbs_virulence_fullgenes_report = "~{samplename}-virulence__fullgenes__GBS_Surface_Genes__results.txt"
        String srst2_gbs_virulenc_HVGA = read_string("HVGA")
        String srst2_gbs_virulance_PI1 = read_string("PI1")
        String srst2_gbs_virulance_PI1B = read_string("PI1B")
        String srst2_gbs_virulance_PI2A1 = read_string("PI2A1")
        String srst2_gbs_virulance_PI2A2 = read_string("PI2A2")
        String srst2_gbs_virulance_PI2A3 = read_string("PI2A3")
        String srst2_gbs_virulance_PI2A4 = read_string("PI2A4")
        String srst2_gbs_virulance_PI2B = read_string("PI2B")
        String srst2_gbs_virulance_PI2B2 = read_string("PI2B2")
    }

    runtime {
        docker: "~{docker}"
        memory: "~{memory} GB"
        cpu: cpu
        disks: "local-disk 100 SSD"
        preemptible: 0
    }

}
