class miniflux {
    include miniflux::vars
    include common::tools::unzip
    include miniflux::install
    include miniflux::jobs
    include miniflux::scripts
    include miniflux::webapp
}
