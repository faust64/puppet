class tftpd::menu::opensuse {
    $distribs = [ "13.2", "13.1" ]
    $distribswtf = [ "42.2", "42.1" ]
    $root_dir = $tftpd::vars::root_dir

    tftpd::define::get_opensuse {
	$distribswtf:
	    arch => [ "x86_64" ];
	$distribs:
    }

    file {
	"Install pxe opensuse boot-screen":
	    content => template("tftpd/opensuse.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "$root_dir/boot-screens/opensuse.cfg",
	    require => File["Prepare boot-screens directory"];
    }
}
