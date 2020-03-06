class cups::debian {
    if ($cups::vars::with_hplip) {
	common::define::package {
	    "hplip":
		require => Package["cups"];
	}
    }

    common::define::package {
	"cups":
    }

    Common::Define::Package["cups"]
	-> File["Prepare cups for further configuration"]
	-> Common::Define::Service[$cups::vars::service_name]
}
