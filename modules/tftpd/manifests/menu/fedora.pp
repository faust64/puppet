class tftpd::menu::fedora {
    $distribs    = [ "23", "22", "21" ]
    $root_dir    = $tftpd::vars::root_dir

    tftpd::define::get_fedora {
	$distribs:
    }

    file {
	"Install pxe fedora boot-screen":
	    content => template("tftpd/fedora.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "$root_dir/boot-screens/fedora.cfg",
	    require => File["Prepare boot-screens directory"];
    }
}
