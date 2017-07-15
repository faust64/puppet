class tftpd::menu::centos {
    $distribs    = [ "om74" ]
    $root_dir    = $tftpd::vars::root_dir

    tftpd::define::get_omsa {
	$distribs:
    }

    file {
	"Install pxe OMSA boot-screen":
	    content => template("tftpd/omsa.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "$root_dir/boot-screens/omsa.cfg",
	    require => File["Prepare boot-screens directory"];
    }
}
