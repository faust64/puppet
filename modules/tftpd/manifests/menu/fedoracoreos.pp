class tftpd::menu::fedoracoreos {
    $distribs = [ "32.20200629.3.0", "31.20200517.3.0" ]
    $keys     = $tftpd::vars::ssh_keys
    $root_dir = $tftpd::vars::root_dir

    tftpd::define::get_fedoracoreos {
	$distribs:
    }

    file {
	"Install pxe fedora-coreos boot-screen":
	    content => template("tftpd/fedora-coreos.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "$root_dir/boot-screens/fedora-coreos.cfg",
	    require =>
		[
		    File["Prepare boot-screens directory"],
		    File["Install fedora-coreos default ignition"]
		];
	"Install fedora-coreos ignition directory":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "$root_dir/fedora-ignition",
	    require => File["Prepare pxe server root"];
	"Install fedora-coreos default ignition":
	    content => template("tftpd/fedora-ignition.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "$root_dir/fedora-ignition/default.ign",
	    require => File["Install fedora-coreos ignition directory"];
    }
}
