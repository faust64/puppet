class aide::scripts {
    $conf_dir = $aide::vars::conf_dir
    $contact  = $aide::vars::contact

    file {
	"Install AIDE check script":
	    content => template("aide/check.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0750",
	    owner   => root,
	    path    => "/usr/local/sbin/check_aide",
	    require => Exec["Install AIDE database"];
    }
}
