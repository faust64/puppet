class autofs::config {
    $conf_dir = $autofs::vars::conf_dir
    $no_dir   = $autofs::vars::no_dir

    file {
	"Prepare autofs for further configuration":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => $conf_dir;
	"Install autofs main configuration":
	    content => template("autofs/master.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    notify  => Service["autofs"],
	    owner   => root,
	    path    => "/etc/auto.master",
	    replace => ! $no_dir,
	    require => File["Prepare autofs for further configuration"];
    }
}
