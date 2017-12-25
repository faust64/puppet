class common::config::udev {
    if ($operatingsystem == "RedHat" or $operatingsystem == "CentOS") {
	$reloadcmd = "udevadm control --reload-rules && udevadm trigger"
    } else { $reloadcmd = "service udev restart" }

    exec {
	"Reload udev configuration":
	    command     => $reloadcmd,
	    onlyif      => "test -d /etc/udev/rules.d",
	    path        => "/usr/local/sbin:/usr/sbin:/sbin:/usr/local/bin:/usr/bin:/bin",
	    refreshonly => true;
    }
}
