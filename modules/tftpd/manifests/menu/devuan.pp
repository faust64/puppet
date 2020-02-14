class tftpd::menu::devuan {
    $distribs    = [ "beowulf", "ascii", "jessie" ]
    $locale      = $tftpd::vars::locale
    $locale_long = $tftpd::vars::locale_long
    $root_dir    = $tftpd::vars::root_dir

    tftpd::define::get_devuan {
	$distribs:
    }

    file {
	"Install pxe devuan boot-screen":
	    content => template("tftpd/devuan.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "$root_dir/boot-screens/devuan.cfg",
	    require => File["Prepare boot-screens directory"];
    }
}
