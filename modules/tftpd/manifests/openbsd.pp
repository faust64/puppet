class tftpd::openbsd {
    $root_dir = $tftpd::vars::root_dir

    file {
	"Prepare tftpd parent directory":
	    ensure => directory,
	    group  => hiera("gid_zero"),
	    mode   => "0755",
	    owner  => root,
	    path   => "/srv";
    }

    file_line {
	"Enable tftpd on boot":
	    line => "tftpd_flags=",
	    path => "/etc/rc.conf.local";
    }

    File["Prepare tftpd parent directory"]
	-> File["Prepare pxe server root"]
}
