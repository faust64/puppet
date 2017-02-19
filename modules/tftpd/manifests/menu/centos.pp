class tftpd::menu::centos {
    $distribs    = [ "6" ]
    $distribswtf = [ "7" ]
    $root_dir    = $tftpd::vars::root_dir

    tftpd::define::get_centos {
	$distribswtf:
	    arch => [ "x86_64" ];
	$distribs:
    }

    file {
	"Install pxe centos boot-screen":
	    content => template("tftpd/centos.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "$root_dir/boot-screens/centos.cfg",
	    require => File["Prepare boot-screens directory"];
    }
}
