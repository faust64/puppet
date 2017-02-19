class pakiti {
    include curl
    include pakiti::vars
    include pakiti::config
    include pakiti::nagios
    include pakiti::register
    include pakiti::scripts
    include pakiti::service
}
