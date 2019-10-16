class tftpd::menu::fedora {
    $distribs    = [ ]
    $distribswtf = [ "30", "29" ]
    $root_dir    = $tftpd::vars::root_dir

    tftpd::define::get_fedora {
	$distribswtf:
	    arch => [ "x86_64" ];
#	$distribs:
    }

    file {
	"Install pxe fedora boot-screen":
	    content => template("tftpd/fedora.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "$root_dir/boot-screens/fedora.cfg",
	    require => File["Prepare boot-screens directory"];
    }
}
