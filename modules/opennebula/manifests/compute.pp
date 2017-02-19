class opennebula::compute {
    $datastore0 = $opennebula::vars::datastore0

    include autofs

    common::define::package {
	"opennebula-node":
    }

    if (defined(Class["Xen"])) { $vmm = "xen4" }
    else { $vmm = "kvm" }

    autofs::define::mount {
	"one":
	    fsopts      => "fstype=nfs,soft,intr,rsize=8192,wsize=8192,noauto,intr",
	    mountpoint  => "/var/lib/one",
	    remotepoint => "$datastore0:/var/lib/one";
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
}
