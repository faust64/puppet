class tftpd::menu::flatcar {
    $distribs = [ "2512.2.1", "2303.4.0" ]
    $keys     = $tftpd::vars::ssh_keys
    $password = $tftpd::vars::default_pass
    $root_dir = $tftpd::vars::root_dir

    tftpd::define::get_flatcar {
	$distribs:
    }

    file {
	"Install pxe FlatCar boot-screen":
	    content => template("tftpd/flatcar.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "$root_dir/boot-screens/flatcar.cfg",
	    require =>
		[
		    File["Prepare boot-screens directory"],
		    File["Install FlatCar default cloud-config"]
		];
	"Install FlatCar cloud-config directory":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "$root_dir/cloud-config",
	    require => File["Prepare pxe server root"];
	"Install FlatCar default cloud-config":
	    content => template("tftpd/cloud-config.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "$root_dir/cloud-config/default.yml",
	    require => File["Install FlatCar cloud-config directory"];
    }
}
