version 1.0

task gbs_sbg_task{
    meta{
        description: "serotyping of Group B Streptococcus GBS"
    }

    input{
        #task inputs
        File assembly
        String samplename
        Int cpu = 2
        String docker = "neranjan007/gbs-sbg:alpha-230926"
        Int memory = 100
    }


    command <<<
        echo ~{assembly}
        echo ~{samplename}

        GBS-SBG.pl \
            ~{assembly} \
            -name ~{samplename} > ~{samplename}_all_report.txt 
        
        GBS-SBG.pl \
            ~{assembly} \
            -name ~{samplename} \
            -best > ~{samplename}_best_report.txt 
        
        awk 'NR==2 {print $2}' ~{samplename}_best_report.txt > SEROTYPE

    >>>

    output{
        File gbs_sbg_report = "~{samplename}_all_report.txt"
        File gbs_sbg_best_report = "~{samplename}_best_report.txt"
        String gbs_sbg_serotype = read_string("SEROTYPE")
    }

    runtime{
        docker: "~{docker}"
        memory: "~{memory} GB"
        cpu: cpu
        disks: "local-disk 50 SSD"
        preemptible: 0
    }
}
