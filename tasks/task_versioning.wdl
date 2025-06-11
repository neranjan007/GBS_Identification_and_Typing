version 1.0

task version_capture {
  input {
    String? timezone
    String docker = "neranjan007/jq:1.6.2"
    Int cpu = 1
    Int memory = 2
  }
  meta {
    volatile: true
  }
  command {
    GBS_Version="GBS v1.4.1"
    ~{default='' 'export TZ=' + timezone}
    date +"%Y-%m-%d" > TODAY
    echo "$GBS_Version" > GBS_VERSION
  }
  output {
    String date = read_string("TODAY")
    String gbs_version = read_string("GBS_VERSION")
  }
  runtime {
        docker: "~{docker}"
        memory: "~{memory} GB"
        cpu: cpu
        disks: "local-disk 50 SSD"
        preemptible: 0 
  }
}