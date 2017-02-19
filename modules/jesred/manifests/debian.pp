class jesred::debian {
    common::define::package {
	"jesred":
    }

    Package["jesred"]
	-> File["Install jesred main configuration"]
	-> File["Install jesred rules configuration"]
	-> File["Install jesred acl configuration"]
}
