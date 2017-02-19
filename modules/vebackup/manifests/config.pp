class vebackup::config {
    $jumeau = $vebackup::vars::jumeau

    @@common::define::lined {
	"Allow $ipaddress to reach ssh port":
	    line    => "sshd: $ipaddress",
	    path    => "/etc/hosts.allow",
	    require => File["Set proper permissions to hosts.allow"],
	    tag     => "tcpwrapper-$hostname";
    }

    file {
	"Prepare VMs dump directory":
	    ensure => directory,
	    group  => hiera("gid_zero"),
	    mode   => "0755",
	    owner  => root,
	    path   => "/media/backups/$jumeau";
    }

    if ($vebackup::do_openvz) {
	file {
	    "Prepare OpenVZ dump directory":
		ensure  => directory,
		group   => hiera("gid_zero"),
		mode    => "0755",
		owner   => root,
		path    => "/media/backups/$jumeau/vz",
		require => File["Prepare VMs dump directory"];
	    "Link OpenVZ dump directory to /media/backup":
		ensure  => link,
		force   => true,
		path    => "/media/backup",
		require => File["Prepare OpenVZ dump directory"],
		target  => "/media/backups/$jumeau/vz";
	}

	File["Prepare OpenVZ dump directory"]
	    -> File["Install Backup-VMs script"]
    }
    if ($vebackup::do_kvm) {
	file {
	    "Prepare KVM dump directory":
		ensure  => directory,
		group   => hiera("gid_zero"),
		mode    => "0755",
		owner   => root,
		path    => "/media/backups/$jumeau/vz",
		require => File["Prepare VMs dump directory"];
	}

	File["Prepare KVM dump directory"]
	    -> File["Install Backup-VMs script"]
    }
}
