class tftpd::menu::coreos {
    $distribs = [ "2135.5.0", "2079.6.0", "2023.5.0" ]
    $keys     = $tftpd::vars::ssh_keys
    $password = $tftpd::vars::default_pass
    $root_dir = $tftpd::vars::root_dir

    tftpd::define::get_coreos {
	$distribs:
    }

    file {
	"Install pxe coreos boot-screen":
	    content => template("tftpd/coreos.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "$root_dir/boot-screens/coreos.cfg",
	    require =>
		[
		    File["Prepare boot-screens directory"],
		    File["Install coreos default cloud-config"]
		];
	"Install coreos cloud-config directory":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "$root_dir/cloud-config",
	    require => File["Prepare pxe server root"];
	"Install coreos default cloud-config":
	    content => template("tftpd/cloud-config.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "$root_dir/cloud-config/default.yml",
	    require => File["Install coreos cloud-config directory"];
    }
}
