class tftpd::menu::satellite {
    $distribs = [ "generic" ]
    $root_dir = $tftpd::vars::root_dir

# use hammer bootdisk generic on your satelliet host to generate bootdisk
# or don't/fixme
    file {
	"Install pxe satellite boot-screen":
	    content => template("tftpd/satellite.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "$root_dir/boot-screens/satellite.cfg",
	    require => File["Prepare boot-screens directory"];
    }
}
