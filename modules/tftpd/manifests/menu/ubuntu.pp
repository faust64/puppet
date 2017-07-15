class tftpd::menu::ubuntu {
    $distribs    = [ "xenial", "trusty", "precise" ]
    $locale      = $tftpd::vars::locale
    $locale_long = $tftpd::vars::locale_long
    $root_dir    = $tftpd::vars::root_dir

    tftpd::define::get_ubuntu {
	$distribs:
    }

    file {
	"Install pxe ubuntu boot-screen":
	    content => template("tftpd/ubuntu.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "$root_dir/boot-screens/ubuntu.cfg",
	    require => File["Prepare boot-screens directory"];
    }
}
