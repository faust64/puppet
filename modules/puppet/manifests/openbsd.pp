class puppet::openbsd {
    include puppet::patches::openbsd

    if (versioncmp($kernelversion, '5.4') <= 0) {
	file {
	    "Install OpenBSD puppet rc script":
		ensure  => present,
		force   => true,
		group   => lookup("gid_zero"),
		mode    => "0555",
		owner   => root,
		path    => "/etc/rc.d/puppetd",
		replace => no,
		source  => "puppet:///modules/puppet/obsd.rc";
	}

	file_line {
	    "Enable Puppet on boot":
		line    => "puppetd_flags=",
		path    => "/etc/rc.conf.local",
		require => File["Install OpenBSD puppet rc script"];
	}

	exec {
	    "Add Puppet to pkg_scripts":
		command => 'echo "pkg_scripts=\"\$pkg_scripts puppetd\"" >>rc.conf.local',
		cwd     => "/etc",
		path    => "/usr/bin:/bin",
		require => File_line["Enable Puppet on boot"],
		unless  => "grep '^pkg_scripts=.*puppetd' rc.conf.local";
	}
    } else {
	file_line {
	    "Enable Puppet on boot":
		line    => "pupped_flags=",
		path    => "/etc/rc.conf.local";
	}

	exec {
	    "Add Puppet to pkg_scripts":
		command => 'echo "pkg_scripts=\"\$pkg_scripts puppet\"" >>rc.conf.local',
		cwd     => "/etc",
		path    => "/usr/bin:/bin",
		require => File_line["Enable Puppet on boot"],
		unless  => "grep '^pkg_scripts=.*puppet' rc.conf.local";
	}
    }

    Exec["Add Puppet to pkg_scripts"]
	-> Common::Define::Service[$puppet::vars::puppet_srvname]
}
