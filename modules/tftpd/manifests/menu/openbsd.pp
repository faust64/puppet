class tftpd::menu::openbsd {
    $distribs = [ "6.8", "6.7", "6.6", "6.5", "6.4" ]
    $root_dir = $tftpd::vars::root_dir

    tftpd::define::get_openbsd {
	$distribs:
    }

    file {
	"Install pxe openbsd boot-screen":
	    content => template("tftpd/openbsd.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "$root_dir/boot-screens/openbsd.cfg",
	    require =>
		[
		    File["Prepare boot-screens directory"],
		    File["Instapp pxe openbsd /etc/boot.conf"]
		];
	"Install pxe openbsd /etc directory":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "$root_dir/etc",
	    require => File["Prepare pxe server root"];
	"Instapp pxe openbsd /etc/boot.conf":
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "$root_dir/etc/boot.conf",
	    require => File["Install pxe openbsd /etc directory"],
	    source  => "puppet:///modules/tftpd/boot.conf";
    }
}
