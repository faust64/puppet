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

    Package["cups"]
	-> File["Prepare cups for further configuration"]
	-> Service[$cups::vars::service_name]
}
