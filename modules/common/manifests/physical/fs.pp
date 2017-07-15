class common::physical::fs {
    $mountpoints = lookup("fstab_mountpoint")
    $root_is_ro  = lookup("fstab_root_ro")

    if ($mountpoints) {
	class {
	    common::fs::fstab:
		stage => "gazelle";
	}
    }
    if ($root_is_ro and $kernel == "Linux") {
	include common::fs::dphysswapfile
	include common::physical::hwclock

	class {
	    common::fs::rw:
		stage => "libellule";
	    unionfs:
		stage => "gazelle";
	    common::fs::ro:
		stage => "gnou";
	}


	if ($mountpoints) {
	    Class[Common::Fs::Rw]
		-> Class[Common::Fs::Fstab]
	}
#    } elsif ($root_is_ro and $kernel == "FreeBSD") {
#mdconfig/mfsroot/... un jour...
    }
}
