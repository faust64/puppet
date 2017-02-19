class openldap::pam::debian {
    common::define::package {
	[ "libpam-ldap", "libnss-ldap" ]:
    }
}
