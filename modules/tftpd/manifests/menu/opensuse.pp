class tftpd::menu::opensuse {
    $distribsleap = [ "15.2" ]
    $root_dir     = $tftpd::vars::root_dir

    tftpd::define::get_opensuse_leap {
	$distribsleap:
    }

    tftpd::define::get_opensuse_tumbleweed {
	"tumbleweed":
    }

    file {
	"Install pxe opensuse boot-screen":
	    content => template("tftpd/opensuse.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "$root_dir/boot-screens/opensuse.cfg",
	    require => File["Prepare boot-screens directory"];
    }
}
