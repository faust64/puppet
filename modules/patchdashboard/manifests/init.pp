class patchdashboard {
    include common::tools::unzip
    include patchdashboard::vars
    include patchdashboard::github
    include patchdashboard::config
    include patchdashboard::collect
    include patchdashboard::webapp
}
