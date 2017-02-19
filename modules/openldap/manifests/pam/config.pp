class openldap::pam::config {
    $ldap_base  = $openldap::vars::ldap_suffix
    $ldap_slave = $openldap::vars::ldap_slave

    file {
	"Install libnss-ldap configuration":
	    content => template("openldap/libnss.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "/etc/libnss-ldap.conf";
	"Link pam_ldap configuration to libnss-ldap.conf":
	    ensure  => link,
	    force   => true,
	    path    => "/etc/pam_ldap.conf",
	    target  => "/etc/libnss-ldap.conf";
	"Install nsswitch.conf":
	    group   => hiera("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "/etc/nsswitch.conf",
	    source  => "puppet:///modules/openldap/nsswitch.conf";
    }

    openldap::define::pam_setup {
	[ "common-account", "common-auth" ]:
    }

    if ($openldap::pam::setup::with_session) {
	openldap::define::pam_setup {
	    [ "common-session", "common-session-noninteractive" ]:
	}
    }
}
