class tftpd::debian {
    $root_dir     = $tftpd::vars::root_dir
    $runtime_user = $tftpd::vars::runtime_user

    common::define::package {
	[ "tftpd-hpa", "syslinux" ]:
    }

    file {
	"Install tftpd service defaults":
	    content => template("tftpd/tftpd-hpa.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0644",
	    notify  => Common::Define::Service["tftpd-hpa"],
	    owner   => root,
	    path    => "/etc/default/tftpd-hpa";
    }

    common::define::service {
	"tftpd-hpa":
	    ensure => running;
    }

    Package["tftpd-hpa"]
	-> File["Install tftpd service defaults"]
	-> Service["tftpd-hpa"]
}
