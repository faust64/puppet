class common::config::udev {
    exec {
	"Reload udev configuration":
	    command     => "service udev restart",
	    onlyif      => "test -d /etc/udev/rules.d",
	    path        => "/usr/local/sbin:/usr/sbin:/sbin:/usr/local/bin:/usr/bin:/bin",
	    refreshonly => true;
    }
}
