class tftpd::menu::mfsbsd {
    $distribs = [ "12.1", "12.0", "11.2" ]
    $root_dir = $tftpd::vars::root_dir

    tftpd::define::get_mfsbsd {
	$distribs:
    }

    file {
	"Install pxe mfsbsd boot-screen":
	    content => template("tftpd/mfsbsd.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "$root_dir/boot-screens/mfsbsd.cfg",
	    require => File["Prepare boot-screens directory"];
    }
}
