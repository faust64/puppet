class unionfs::debian {
    common::define::package {
	"unionfs-fuse":
    }

    Package["unionfs-fuse"]
	-> File["Install mount_unionfs script"]
}
