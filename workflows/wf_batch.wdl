version 1.0

import "wf_gbs_id_and_typing.wdl" as gbs_typing 


workflow batch_gbs {
    input {
        # arry input
        File inputBatchFile
        Array[Array[File]] inputSamples = read_tsv(inputBatchFile)
        File kraken2_database
        String? emmtypingtool_docker_image
        File? referance_genome
    }

    scatter (sample in inputSamples) {
        call gbs_typing.GBS_identification_n_typing_workflow {
            input:
                samplename = sample[0],
                R1 = sample[1],
                R2 = sample[2],
                kraken2_database = kraken2_database,
                emmtypingtool_docker_image = emmtypingtool_docker_image,
                referance_genome = referance_genome
        }
    }

}

