class tftpd::menu::mfsbsd {
    $distribs    = [ "10.0", "9.2", "9.1", "9.0", "8.4", "8.3" ]
    $distribswtf = [ "10.3", "10.2", "10.1" ]
    $root_dir    = $tftpd::vars::root_dir

    tftpd::define::get_mfsbsd {
	$distribswtf:
	    arch => [ "amd64" ];
	$distribs:
    }

    file {
	"Install pxe mfsbsd boot-screen":
	    content => template("tftpd/mfsbsd.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "$root_dir/boot-screens/mfsbsd.cfg",
	    require => File["Prepare boot-screens directory"];
    }
}
