class named::scripts {
    $contact    = $named::vars::contact
    $do_domains = $named::vars::do_domains
    $jumeau     = $named::vars::jumeau
    $ldap_slave = $named::vars::openldap_ldap_slave
    $rgroup     = $named::vars::runtime_group
    $ruser      = $named::vars::runtime_user
    $rzone_dir  = $named::vars::runtime_zone_dir
    $srvname    = $named::vars::service_name
    $ssh_port   = $named::vars::ssh_port
    $zones      = $named::vars::zones_check
    $zone_dir   = $named::vars::zone_dir

    if ($named::vars::is_datacenter == false and $ldap_slave) {
	file {
	    "Install update_directory script":
		content => template("named/update_directory.erb"),
		group   => lookup("gid_zero"),
		mode    => "0750",
		owner   => root,
		path    => "/usr/local/sbin/update_directory";
	}
    }

    if ($named::vars::named_master == false) {
	if ($named::vars::sshfp_domains != false) {
	    each($named::vars::sshfp_domains) |$zone| {
		Common::Define::Lined <<| tag == "sshfp-records-$zone" |>>
	    }
	}
	each($do_domains) |$zone| {
	    Common::Define::Lined <<| tag == "opendkim-$zone" |>>
	}

	exec {
	    "Update DNS configuration":
		command     => "/usr/local/sbin/dnsgen",
		cwd         => "/usr/share/dnsgen",
		refreshonly => true,
		require     => File["Install split-horizon generator"];
	}

	file {
	    "Install zonedit.sh":
		group   => lookup("gid_zero"),
		mode    => "0700",
		owner   => root,
		path    => "/usr/local/sbin/zonedit.sh",
		source  => "puppet:///modules/named/zonedit.sh";
	    "Install checkzone":
		content => template("named/checkzone.erb"),
		group   => lookup("gid_zero"),
		mode    => "0700",
		owner   => root,
		path    => "/usr/local/sbin/checkzone";
	    "Install dnschk":
		content => template("named/dnschk.erb"),
		group   => lookup("gid_zero"),
		mode    => "0700",
		owner   => root,
		path    => "/usr/local/sbin/dnschk";

	    "Install split-horizon generator share directory":
		ensure  => directory,
		group   => lookup("gid_zero"),
		mode    => "0755",
		owner   => root,
		path    => "/usr/share/dnsgen";
	    "Install split-horizon generator ressources directory":
		ensure  => directory,
		group   => lookup("gid_zero"),
		mode    => "0755",
		owner   => root,
		path    => "/usr/share/dnsgen/ressources",
		require => File["Install split-horizon generator share directory"];
	    "Install split-horizon generator SOA template":
		group   => lookup("gid_zero"),
		mode    => "0700",
		owner   => root,
		path    => "/usr/share/dnsgen/ressources/soa",
		require => File["Install split-horizon generator ressources directory"],
		source  => "puppet:///modules/named/soa";
	    "Install split-horizon generator generic vars":
		group   => lookup("gid_zero"),
		mode    => "0700",
		owner   => root,
		path    => "/usr/share/dnsgen/ressources/vars",
		require => File["Install split-horizon generator ressources directory"],
		replace => no,
		source  => "puppet:///modules/named/vars";
	    "Install split-horizon generator public-view directory":
		ensure  => directory,
		group   => lookup("gid_zero"),
		mode    => "0755",
		owner   => root,
		path    => "/usr/share/dnsgen/public-view.d",
		require => File["Install split-horizon generator share directory"];
#then, create your own ${something}-view.d
	    "Install split-horizon generator":
		content => template("named/generate.erb"),
		group   => lookup("gid_zero"),
		mode    => "0700",
		owner   => root,
		path    => "/usr/local/sbin/dnsgen",
		require =>
		    [
			File["Install split-horizon generator public-view directory"],
			File["Install split-horizon generator SOA template"],
			File["Install split-horizon generator generic vars"]
		    ];
	}
    }
}
