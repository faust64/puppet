class camtrace::webapp {
    include postgres
    include apache

    apache::define::vhost {
	"camtrace.$domain":
	    app_root => "/usr/local/camtrace/www";
    }
}
