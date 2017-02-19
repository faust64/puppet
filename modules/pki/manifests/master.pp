class pki::master {
    include pki::crl
    include pki::config
    include pki::scripts
    include pki::jobs
}
