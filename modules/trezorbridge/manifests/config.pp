class trezorbridge::config {
    file {
	"Install trezord log file":
	    ensure  => present,
	    group   => "trezord",
	    mode    => "0660",
	    owner   => "trezord",
	    path    => "/var/log/trezord.log",
	    require => User["trezord"];
    }

    if ($kernel == "Linux") {
	file {
	    "Install Trezor udev rules":
		group   => lookup("gid_zero"),
		mode    => "0644",
		notify => Exec["Reload udev configuration"],
		owner   => "root",
		path    => "/etc/udev/rules.d/71-trezor.rules",
		source  => "puppet:///modules/trezorbridge/udev";
	}
    }
}
