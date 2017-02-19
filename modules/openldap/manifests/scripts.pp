class openldap::scripts {
    $slack_hook = $openldap::vars::slack_hook

    file {
	"Install OpenLDAP backup script":
	    content => template("openldap/backup.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0750",
	    owner   => root,
	    path    => "/usr/local/sbin/OpenLDAPbackup",
	    require => Service[$openldap::vars::service_name];
    }
}
