class openldap::nagios {
    $ldap_base = $openldap::vars::ldap_suffix

    nagios::define::probe {
	"slapd":
	    command       => "check_ldap",
	    description   => "$fqdn LDAP server",
	    pluginargs    =>
		[
		    "-H localhost",
		    "-b '$ldap_base'",
		    "-p 636",
		    "-3"
		],
	    servicegroups => "authentication",
	    use           => "critical-service";
    }
}
