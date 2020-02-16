class nextcloud {
    include openldap::client
    include nextcloud::vars
    include nextcloud::install
    include nextcloud::config
    include nextcloud::jobs
    include nextcloud::scripts
    include nextcloud::webapp
}
