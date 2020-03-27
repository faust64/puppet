class katello::config::auth {
    katello::define::authsource { "LDAP-UTGB": }

    katello::define::usergroup {
	"LDAP-Admins":
	    admin      => true,
	    authsource => "LDAP-UTGB",
	    ldapgroup  => "admins";
    }
}
