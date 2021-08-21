class tftpd::menu::debian {
    $distribs    = [ "bullseye", "buster", "stretch" ]
    $locale      = $tftpd::vars::locale
    $locale_long = $tftpd::vars::locale_long
    $root_dir    = $tftpd::vars::root_dir

    tftpd::define::get_debian {
	$distribs:
    }

    file {
	"Install pxe debian boot-screen":
	    content => template("tftpd/debian.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "$root_dir/boot-screens/debian.cfg",
	    require => File["Prepare boot-screens directory"];
    }
}
