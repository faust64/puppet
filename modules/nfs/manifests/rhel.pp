class nfs::rhel {
    common::define::package {
	"nfs-utils":
    }

    Package["nfs-utils"]
	-> File["Install NFS exports"]
}
