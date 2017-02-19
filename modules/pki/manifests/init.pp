class pki {
    include pki::vars

    if ($fqdn == $pki::vars::pki_master) {
	include pki::master
    }
    else {
	include pki::client
    }
}
