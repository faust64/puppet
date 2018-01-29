class tftpd::menu::redhat {
    $distribs = [ "7.4" ]
    $rhrepo   = $tftpd::vars::rhrepo
    $rhroot   = $tftpd::vars::rhroot
    $root_dir = $tftpd::vars::root_dir

    tftpd::define::get_redhat {
	$distribs:
    }

    file {
	"Install pxe redhat boot-screen":
	    content => template("tftpd/redhat.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "$root_dir/boot-screens/redhat.cfg",
	    require => File["Prepare boot-screens directory"];
    }
}
