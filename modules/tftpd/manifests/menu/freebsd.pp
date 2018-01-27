class tftpd::menu::freebsd {
#   $distribs = [ "10.1", "9.2", "8.4" ]
    $distribs = [ "11.1", "11.0", "10.4" ]
    $root_dir = $tftpd::vars::root_dir

    tftpd::define::get_freebsd {
	$distribs:
    }

    file {
	"Install pxe freebsd boot-screen":
	    content => template("tftpd/freebsd.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "$root_dir/boot-screens/freebsd.cfg",
	    require => File["Prepare boot-screens directory"];
    }
}
