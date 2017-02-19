class pakitiserver {
    include pakitiserver::vars
    include pakitiserver::install
    include pakitiserver::collect
    include pakitiserver::config
    include pakitiserver::patches
    include pakitiserver::service
    include pakitiserver::webapp
}
