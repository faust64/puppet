define openldap::define::pam_setup() {
    file {
	"Install $name pam configuration":
	    group   => hiera("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "/etc/pam.d/$name",
	    require => File["Link pam_ldap configuration to libnss-ldap.conf"],
	    source  => "puppet:///modules/openldap/pam/$name";
    }
}
