class common::fs::dphysswapfile {
    exec {
	"Stop dphys-swapfile service":
	    command => "./dphys-swapfile stop",
	    cwd     => "/etc/init.d",
	    path    => "/usr/sbin:/sbin:/usr/bin:/bin",
	    onlyif  => "test -x dphys-swapfile";
    }

    each([ "init.d/", "rc2.d/S02", "rc3.d/S02", "rc4.d/S02", "rc5.d/S02" ]) |$rc| {
	file {
	    "Drop ${rc}dphys-swapfile":
		ensure  => absent,
		force   => true,
		path    => "/etc/${rc}dphys-swapfile",
		require => Exec["Stop dphys-swapfile service"];
	}
    }

    file {
	"Drop swap file":
	    ensure  => absent,
	    force   => true,
	    path    => "/var/swap",
	    require => Exec["Stop dphys-swapfile service"];
    }
}
