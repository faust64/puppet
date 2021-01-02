class tftpd::menu::freebsd {
    $distribs = [ "12.2", "11.4" ]
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
