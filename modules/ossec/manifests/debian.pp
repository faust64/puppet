class ossec::debian {
    if ($ossec::vars::manager == false) {
	$pkgname = "ossec-hids"

	Package[$pkgname]
	    -> File["Install ossec-authd service script"]
    } else {
	$manager = $ossec::vars::manager
	$pkgname = "ossec-hids-agent"

	Package[$pkgname]
	    -> Exec["OSSEC register to $manager"]
    }

    file {
	"Drop OSSEC former logrotate configuration":
	    ensure => absent,
	    force  => true,
	    path   => "/etc/logrotate.d/ossec-hids";
    }

    apt::define::aptkey {
	"Santiago Bassett":
	    url => "http://ossec.wazuh.com/repos/apt/conf/ossec-key.gpg.key";
    }

    if ($operatingsystem == "Debian" or $myoperatingsystem == "Devuan") {
	$baseurl = "http://ossec.wazuh.com/repos/apt/debian"
    } else {
	$baseurl = "http://ossec.wazuh.com/repos/apt/ubuntu"
    }

    apt::define::repo {
	"wazuh":
	    baseurl => $baseurl,
	    require => Apt::Define::Aptkey["Santiago Bassett"];
    }

    common::define::package {
	$pkgname:
	    require =>
		[
		    Apt::Define::Repo["wazuh"],
		    Exec["Update APT local cache"]
		];
    }

    Package[$pkgname]
	-> File["Drop OSSEC former logrotate configuration"]
	-> File["Install ossec main configuration"]
}
