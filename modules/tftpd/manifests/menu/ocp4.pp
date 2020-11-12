class tftpd::menu::ocp4 {
    $distribs = [ "4.6.1" ]
    $keys     = $tftpd::vars::ssh_keys
    $password = $tftpd::vars::default_pass
    $root_dir = $tftpd::vars::root_dir

    tftpd::define::get_ocp4 {
	$distribs:
    }

    file {
	"Install pxe ocp4 boot-screen":
	    content => template("tftpd/ocp4.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "$root_dir/boot-screens/ocp4.cfg",
	    require =>
		[
		    File["Prepare boot-screens directory"],
		    File["Prepare OCP4 RH-CoreOS ignition assets directory"]
		];
	"Prepare OCP4 RH-CoreOS ignition assets directory":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "$root_dir/ocp4",
	    require => File["Prepare pxe server root"];
    }
}
