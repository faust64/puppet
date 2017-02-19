class asterisk::iax {
    $array_dom    = split($domain, '\.')
    $calltoken    = $asterisk::vars::calltoken_optional
    $codecs       = $asterisk::vars::preferred_codecs
    $conf_dir     = $asterisk::vars::conf_dir
    $port         = $asterisk::vars::iax_port
    $here_priv    = $array_dom[0]
    $here_pub     = "${here_priv}_pub"
    $trunks       = $asterisk::vars::iax_trunks

    file {
	"Install Asterisk IAX main configuration":
	    content => template("asterisk/iaxs.erb"),
	    group   => $asterisk::vars::runtime_group,
	    mode    => "0640",
	    notify  => Exec["Reload IAX configuration"],
	    owner   => $asterisk::vars::runtime_user,
	    path    => "$conf_dir/iax.conf",
	    require => File["Prepare Asterisk for further configuration"];
	"Install Asterisk IAX provisioning configuration":
	    content => template("asterisk/iaxprov.erb"),
	    group   => $asterisk::vars::runtime_group,
	    mode    => "0640",
	    notify  => Exec["Reload IAX configuration"],
	    owner   => $asterisk::vars::runtime_user,
	    path    => "$conf_dir/iaxprov.conf",
	    require => File["Prepare Asterisk for further configuration"];
    }

    if ($trunks) {
	create_resources(asterisk::define::iax, $trunks)
    }
}
