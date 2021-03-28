class katello::config::lce {
    katello::define::lifecycleenvironment {
	"Prod":
	    parent => "Dev";
	"Dev":
    }
}
