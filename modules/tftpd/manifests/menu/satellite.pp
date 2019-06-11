class tftpd::menu::satellite {
    $rhrepo   = $tftpd::vars::rhrepo
    $root_dir = $tftpd::vars::root_dir

    file {
	"Install pxe satellite boot-screen":
	    content => template("tftpd/satellite.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "$root_dir/boot-screens/satellite.cfg",
	    require => File["Prepare boot-screens directory"];
    }
}
