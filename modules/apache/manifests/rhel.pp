class apache::rhel {
    common::define::package {
	[ "httpd", "nagios-plugins-http" ]:
    }

    if ($apache::vars::apache_debugs) {
	common::define::package {
	    "apachetop":
	}
    }
}
