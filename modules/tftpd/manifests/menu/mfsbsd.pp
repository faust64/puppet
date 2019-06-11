class tftpd::menu::mfsbsd {
    $distribs    = [ ]
    $distribswtf = [ "12.0", "11.2", "11.1" ]
    $root_dir    = $tftpd::vars::root_dir

    tftpd::define::get_mfsbsd {
	$distribswtf:
	    arch => [ "amd64" ];
#	$distribs:
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
