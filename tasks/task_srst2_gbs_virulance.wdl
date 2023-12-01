version 1.0

task srst2_gbs_virulence_task{
    meta{
        description: "Short Read Sequence virulence genes : GBS"
    }

    input{
        #task inputs
        File read1
        File read2
        Boolean postfix = false
        String read1_postfix = "_R1"
        String read2_postfix = "_R2"
        Int cpu = 4
        String docker = "neranjan007/srst2:0.2.0-gbs-surfaceGenes"
        Int memory = 100
        String samplename
    }

    command <<<
    
        if [[ "~{postfix}" == "true" ]]; then
            INPUT_READS="--input_pe ~{read1} ~{read2} --forward ~{read1_postfix} --reverse _~{read2_postfix}"
            echo "  ${INPUT_READS} "
            echo " terra is true"
        else
            INPUT_READS="--input_pe ~{read1} ~{read2}"
            echo " ${INPUT_READS} "
            echo " terra is false"
        fi

    
        srst2 --samtools_args '\\-A' ${INPUT_READS} --output ~{samplename}-virulence --log --gene_db /gbs-db/GBS_Surface_Genes.fasta --min_coverage 99.0 --max_divergence 8 --threads ~{cpu}

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
            awk ' $3=="HVGA" { print $4} ' ~{samplename}-virulence__fullgenes__GBS_Surface_Genes__results.txt > HVGA
            # pili
            awk ' $3=="PI1" { print $4 } ' ~{samplename}-virulence__fullgenes__GBS_Surface_Genes__results.txt > PI1
            awk ' $3=="PI1B " { print $4 } ' ~{samplename}-virulence__fullgenes__GBS_Surface_Genes__results.txt > PI1B
            awk ' $3=="PI2A1"  { print $4 } ' ~{samplename}-virulence__fullgenes__GBS_Surface_Genes__results.txt > PI2A1
            awk ' $3=="PI2A2"  { print $4 } ' ~{samplename}-virulence__fullgenes__GBS_Surface_Genes__results.txt > PI2A2
            awk ' $3=="PI2A3"  { print $4 } ' ~{samplename}-virulence__fullgenes__GBS_Surface_Genes__results.txt > PI2A3
            awk ' $3=="PI2A4"  { print $4 } ' ~{samplename}-virulence__fullgenes__GBS_Surface_Genes__results.txt > PI2A4
            awk ' $3=="PI2B"  { print $4 } ' ~{samplename}-virulence__fullgenes__GBS_Surface_Genes__results.txt > PI2B
            awk ' $3=="PI2B2"  { print $4 } ' ~{samplename}-virulence__fullgenes__GBS_Surface_Genes__results.txt > PI2B2
            # Serine rich repeat protein
            awk ' $3=="SRR1" { print $4} ' ~{samplename}-virulence__fullgenes__GBS_Surface_Genes__results.txt > SRR1
            awk ' $3=="SRR2" { print $4} ' ~{samplename}-virulence__fullgenes__GBS_Surface_Genes__results.txt > SRR2
            # alpha like protein
            awk ' $3=="ALP1" { print $4} ' ~{samplename}-virulence__fullgenes__GBS_Surface_Genes__results.txt > ALP1
            awk ' $3=="ALP23" { print $4} ' ~{samplename}-virulence__fullgenes__GBS_Surface_Genes__results.txt > ALP23
            awk ' $3=="ALPHA" { print $4} ' ~{samplename}-virulence__fullgenes__GBS_Surface_Genes__results.txt > ALPHA
            awk ' $3=="RIB" { print $4} ' ~{samplename}-virulence__fullgenes__GBS_Surface_Genes__results.txt > RIB

        else
            echo "fullgenes__GBS_Surface_Genes__results.txt file not present"
            echo "No fullgenes file produced" > ~{samplename}-virulence__fullgenes__GBS_Surface_Genes__results.txt
        fi

    >>>

    output{
        File srst2_virulence_report = "~{samplename}-virulence__genes__GBS_Surface_Genes__results.txt"
        File srst2_virulence_fullgenes_report = "~{samplename}-virulence__fullgenes__GBS_Surface_Genes__results.txt"
        String srst2_HVGA = read_string("HVGA")
        String srst2_PI1 = read_string("PI1")
        String srst2_PI1B = read_string("PI1B")
        String srst2_PI2A1 = read_string("PI2A1")
        String srst2_PI2A2 = read_string("PI2A2")
        String srst2_PI2A3 = read_string("PI2A3")
        String srst2_PI2A4 = read_string("PI2A4")
        String srst2_PI2B = read_string("PI2B")
        String srst2_PI2B2 = read_string("PI2B2")
        String srst2_SRR1 = read_string("SRR1")
        String srst2_SRR2 = read_string("SRR2")
        String srst2_ALP1 = read_string("ALP1")
        String srst2_ALP23 = read_string("ALP23")
        String srst2_ALPHA = read_string("ALPHA")
        String srst2_RIB = read_string("RIB")

    }

    runtime {
        docker: "~{docker}"
        memory: "~{memory} GB"
        cpu: cpu
        disks: "local-disk 100 SSD"
        preemptible: 0
    }

}
