class aptcacherng::debian {
    common::define::package {
	"apt-cacher-ng":
    }

    Package["apt-cacher-ng"]
	-> Service["apt-cacher-ng"]
#	-> File["Install APT main configuration"]
}
