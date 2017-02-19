class saslauthd::config {
    $conf_dir         = $saslauthd::vars::conf_dir
    $ldap_passphrase  = $saslauthd::vars::ldap_passphrase
    $ldap_slave       = $saslauthd::vars::ldap_slave
    $ldap_user        = $saslauthd::vars::ldap_user
    $search_base      = $saslauthd::vars::search_base
    $search_filter    = $saslauthd::vars::search_filter

    file {
	"Install Saslauthd main configuration":
	    content => template("saslauthd/config.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0644",
	    notify  => Service["saslauthd"],
	    owner   => root,
	    path    => "$conf_dir/saslauthd.conf";
    }
}
