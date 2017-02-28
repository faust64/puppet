class openldap::config {
    $admin_ssha     = $openldap::vars::admin_ssha
    $cert_dir       = $openldap::vars::cert_dir
    $conf_dir       = $openldap::vars::conf_dir
    $dir_dir        = $openldap::vars::the_dir
    $ldap_slave     = $openldap::vars::ldap_slave
    $ldap_id        = $openldap::vars::ldap_id
    $repl_dn_passwd = $openldap::vars::repl_dn_passwd
    $run_dir        = $openldap::vars::run_dir
    $runtime_group  = $openldap::vars::runtime_group
    $runtime_user   = $openldap::vars::runtime_user
    $suffix         = $openldap::vars::ldap_suffix

    file {
	"Prepare OpenLDAP SSL directory":
	    ensure  => directory,
	    group   => $openldap::vars::runtime_group,
	    mode    => "0755",
	    owner   => $openldap::vars::runtime_user,
	    path    => "$conf_dir/ssl",
	    require => File["Prepare OpenLDAP for further configuration"];
	"Prepare OpenLDAP schema directory":
	    ensure  => directory,
	    group   => hiera("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "$conf_dir/schema",
	    require => File["Prepare OpenLDAP for further configuration"];
	"Install OpenLDAP main configuration":
	    content => template("openldap/slapd.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0600",
	    notify  => Service[$openldap::vars::service_name],
	    owner   => $runtime_user,
	    path    => "$conf_dir/slapd.conf",
	    require => File["Prepare OpenLDAP for further configuration"];
    }

    openldap::define::schema {
	[ "UTGB", "asterisk", "dlz", "dhcp", "kerberos", "openssh-lpk", "samba" ]:
    }

    pki::define::wrap {
	$openldap::vars::service_name:
	    ca      => "auth",
	    group   => $runtime_group,
	    mode    => "0640",
	    owner   => root,
	    reqfile => "Prepare OpenLDAP SSL directory",
	    within  => "$conf_dir/ssl";
    }
}
