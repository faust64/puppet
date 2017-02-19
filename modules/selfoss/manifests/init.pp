class selfoss {
    include selfoss::vars
    include common::tools::unzip
    include selfoss::config
    include selfoss::install
    include selfoss::jobs
    include selfoss::webapp
}
