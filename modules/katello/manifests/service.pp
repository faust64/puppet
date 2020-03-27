class katello::service {
    each($katello::vars::katello_services) |$svc| {
	common::define::service {
	    $svc:
		ensure  => running,
		require => Exec["Reload Katello Services"];
	}
    }
}
