class asterisk::sip {
    $codecs     = $asterisk::vars::preferred_codecs
    $conf_dir   = $asterisk::vars::conf_dir
    $extensions = $asterisk::vars::extensions
    $externalip = $asterisk::vars::externalip
    $locale     = $asterisk::vars::locale
    $localnet   = $asterisk::vars::localnet
    $regtimeout = $asterisk::vars::register_timeout
    $trunks     = $asterisk::vars::sip_trunks

    file {
	"Install Asterisk SIP main configuration":
	    content => template("asterisk/sip.erb"),
	    group   => $asterisk::vars::nagios_runtime_group,
	    mode    => "0640",
	    notify  => Exec["Reload SIP configuration"],
	    owner   => $asterisk::vars::runtime_user,
	    path    => "$conf_dir/sip.conf",
	    require => File["Prepare Asterisk for further configuration"];
	"Install Asterisk SIP notify configuration":
	    group   => $asterisk::vars::runtime_group,
	    mode    => "0640",
	    notify  => Exec["Reload SIP configuration"],
	    owner   => $asterisk::vars::runtime_user,
	    path    => "$conf_dir/sip_notify.conf",
	    require => File["Prepare Asterisk for further configuration"],
	    source  => "puppet:///modules/asterisk/sip_notify.conf";
    }

    if ($trunks) {
	create_resources(asterisk::define::siptrunk, $trunks)
    }
}
