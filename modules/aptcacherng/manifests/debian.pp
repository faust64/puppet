class aptcacherng::debian {
    common::define::package {
	"apt-cacher-ng":
    }

    Common::Define::Package["apt-cacher-ng"]
	-> Common::Define::Service["apt-cacher-ng"]
#	-> File["Install APT main configuration"]
}
