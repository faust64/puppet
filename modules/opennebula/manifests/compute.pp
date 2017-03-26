class opennebula::compute {
    $nebula_vers = $opennebula::vars::version

    common::define::package {
	"opennebula-node":
    }

    if (defined(Class["Xen"])) { $vmm = "xen4" }
    else { $vmm = "kvm" }


    if (versioncmp("$nebula_vers", '5.0') <= 0) {
	include autofs

	$controller = $opennebula::vars::controller

	autofs::define::mount {
	    "one":
		fsopts      => "fstype=nfs,soft,intr,rsize=8192,wsize=8192,noauto,intr",
		mountpoint  => "/var/lib/one",
		remotepoint => "$controller:/var/lib/one";
	}

	@@exec {
	    "Declare $fqdn host":
		command => "onehost create $fqdn -i $vmm -v $vmm -n dummy",
		cwd     => "/",
		onlyif  => "onehost show $fqdn | grep 'not found'",
		path    => "/usr/bin:/bin",
		tag     => "nebula-compute-host",
		require => Exec["Copy local ssh key to authorized keys"],
		user    => $opennebula::vars::runtime_user;
	}
    } else {
	@@exec {
	    "Declare $fqdn host":
		command => "onehost create $fqdn -i $vmm -v $vmm",
		cwd     => "/",
		onlyif  => "onehost show $fqdn | grep 'not found'",
		path    => "/usr/bin:/bin",
		tag     => "nebula-compute-host",
		require => Exec["Copy local ssh key to authorized keys"],
		user    => $opennebula::vars::runtime_user;
	}

	File <<| tag == "nebula-ssh-key" |>>
    }

    Common::Define::Package["opennebula-node"]
	-> Common::Define::Package["opennebula-common"]
}
