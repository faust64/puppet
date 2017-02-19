class samba::nagios {
    $ldap_slave = $samba::vars::ldap_slave
    $ldap_sfx   = $samba::vars::samba_ldap_sfx

    nagios::define::probe {
	"authldap":
	    command       => "check_nrpe!check_ldap",
	    description   => "$fqdn Samba auth provider",
	    pluginargs    =>
		[
		    "-H $ldap_slave",
		    "-b '$ldap_sfx'",
		    "-p 636",
		    "-3"
		],
	    servicegroups => "authentication",
	    use           => "jobs-service";
	"nmbd":
	    description   => "$fqdn nmbd server",
	    servicegroups => "netservices",
	    use           => "critical-service";
	"smbd":
	    description   => "$fqdn smbd server",
	    servicegroups => "netservices",
	    use           => "critical-service";
    }
}
