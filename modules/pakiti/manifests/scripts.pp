class pakiti::scripts {
    $cert_dir = $pakiti::vars::cert_dir
    $conf_dir = $pakiti::vars::conf_dir

    file {
	"Install Pakiti script":
	    content => template("pakiti/pakiti.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0750",
	    owner   => root,
	    path    => "/usr/sbin/pakiti2-client";
    }
}
