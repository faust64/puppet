class openldap::openbsd($server = false) {
    $conf_dir  = $openldap::vars::conf_dir
    $run_group = $openldap::vars::runtime_group
    $run_user  = $openldap::vars::runtime_user

    if ($server) {
	$ensure = "present"
    } else {
	$ensure = "absent"
    }

    if ($ensure != "absent") {
	common::define::package {
	    [ "cyrus-sasl", "openldap-server", "nagios-plugins-ldap" ]:
		ensure => $ensure;
	}
    }

    common::define::package {
	"openldap-client":
    }

    common::define::lined {
	"Enable OpenLDAP on boot":
	    line   => "slapd_flags='-u $run_user -g $run_group -4 -h ldap:///\\ ldaps:///'",
	    ensure => $ensure,
	    match  => 'slapd_flags=',
	    path   => "/etc/rc.conf.local";
    }

    if ($server) {
	exec {
	    "Add OpenLDAP to pkg_scripts":
		command => 'echo "pkg_scripts=\"\$pkg_scripts slapd\"" >>rc.conf.local',
		cwd     => "/etc",
		path    => "/usr/bin:/bin",
		require => File_line["Enable OpenLDAP on boot"],
		unless  => "grep '^pkg_scripts=.*slapd' rc.conf.local";
	}

	file {
	    "Install OpenBSD link to slapd.conf":
		ensure => link,
		force  => true,
		path   => "/etc/ldapd.conf",
		target => "$conf_dir/slapd.conf";
	}

	Package["openldap-server"]
	    -> File_line["Enable OpenLDAP on boot"]
	    -> Exec["Add OpenLDAP to pkg_scripts"]
	    -> File["Prepare OpenLDAP for further configuration"]
	    -> Common::Define::Service[$openldap::vars::service_name]
    }
}
