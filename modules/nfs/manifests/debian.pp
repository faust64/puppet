class nfs::debian {
    common::define::package {
	"nfs-kernel-server":
    }

    Package["nfs-kernel-server"]
	-> File["Install NFS exports"]
}
