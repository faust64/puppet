class pki::vars {
    $ca_expire      = hiera("pki_ca_expire")
    $contact        = hiera("pki_contact")
    $domains_lookup = hiera("pki_domains_lookup")
    $key_city       = hiera("pki_key_city")
    $key_country    = hiera("pki_key_country")
    $key_expire     = hiera("pki_key_expire")
    $key_org        = hiera("pki_key_org")
    $key_province   = hiera("pki_key_province")
    $key_size       = hiera("pki_key_size")
    $listen_ports   = hiera("apache_listen_ports")
    $pki_master     = hiera("pki_master")
    $pki_public     = hiera("pki_public")
    $nocontact      = hiera("pki_nocontact")
    $ovpngw         = hiera("openvpn_gateway")
    $search_user    = hiera("openvpn_searchuser")
    $zip_pass       = hiera("zip_password")
}
