class apache::modsecurity {
    $office_networks = $apache::vars::office_networks
    $srvname         = $apache::vars::service_name
    $version         = $apache::vars::version

    file {
	"Install mod_security main configuration":
	    content => template("apache/mod_security.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    notify  => Service[$srvname],
	    owner   => root,
	    path    => "/etc/modsecurity/modsecurity.conf";
    }

    if ($apache::vars::owsap_security == true) {
	common::define::geturl {
	    "OWSAP modsecurity ruleset":
		notify => Exec["Extract OWSAP modsecurity ruleset"],
		target => "/root/security_rset.tar.gz",
		url    => "https://github.com/SpiderLabs/owasp-modsecurity-crs/tarball/master",
		wd     => "/root";
	}

	exec {
	    "Extract OWSAP modsecurity ruleset":
		command     => "tar -xzf /root/security_rset.tar.gz",
		cwd         => "/usr/share",
		path        => "/usr/bin:/bin",
		unless      => "test -s security_rset.tar.gz";
	    "Link owsap-modsecurity-crs to extracted directory":
		command     => "ln -sf SpiderLabs-owsap-modsecurity-crs-* owsap-modsecurity-crs",
		creates     => "/usr/share/owsap-modsecurity-crs",
		cwd         => "/usr/share",
		notify      => Service[$srvname],
		path        => "/usr/bin:/bin";
	}

	Common::Define::Geturl["OWSAP modsecurity ruleset"]
	    -> Exec["Extract OWSAP modsecurity ruleset"]
	    -> Exec["Link owsap-modsecurity-crs to extracted directory"]
	    -> File["Install mod_security main configuration"]
    }

    File["Install mod_security main configuration"]
	-> File["Drop apache misnamed mod-security module configuration"]
	-> File["Drop apache misnamed mod-security module loading"]
	-> Apache::Define::Module["security2"]
}
