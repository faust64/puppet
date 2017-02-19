class tftpd::webapp {
    $root_dir = $tftpd::vars::root_dir

    nginx::define::vhost {
	"pxe.$domain":
	    app_root => $root_dir,
	    require  => File["Prepare pxe server root"];
    }

    file {
	"Prepare preseed directory":
	    ensure  => directory,
	    group   => hiera("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "$root_dir/preseed",
	    require => File["Prepare pxe server root"];
	"Prepare kickstart directory":
	    ensure  => directory,
	    group   => hiera("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "$root_dir/ks",
	    require => File["Prepare pxe server root"];
    }

    tftpd::define::ui_openbsd {
	"generic":
    }
}
