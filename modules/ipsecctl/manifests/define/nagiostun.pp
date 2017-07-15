define ipsecctl::define::nagiostun() {
    $nagios_user = $ipsecctl::vars::nagios_runtime_user
    $remname     = regsubst($name, '[\. ]', '_', 'G')
    $sudo_conf_d = $ipsecctl::vars::sudo_conf_dir

    if (! defined(File["Add nagios user to sudoers for check_ipsec probe"])) {
	include sudo

	file {
	    "Add nagios user to sudoers for check_ipsec probe":
		content => template("ipsecctl/nagios.sudoers.erb"),
		group   => lookup("gid_zero"),
		mode    => "0440",
		owner   => root,
		path    => "$sudo_conf_d/sudoers.d/nagios-ipsecctl",
		require => File["Prepare sudo for further configuration"];
	}
    }

    nagios::define::probe {
	"ipsec_${remname}":
	    description   => "$fqdn IPSEC to $remname",
	    pluginargs    => [ "'$remname'" ],
	    pluginconf    => "ipsec",
	    servicegroups => "vpn",
	    use           => "error-service";
    }
}
