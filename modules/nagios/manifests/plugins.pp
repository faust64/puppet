class nagios::plugins {
    file {
	"Install Nagios custom plugins":
	    group   => lookup("gid_zero"),
	    ignore  => [ ".svn", ".git", "check_dhcp" ],
	    mode    => "0755",
	    owner   => root,
	    path    => $nagios::vars::nagios_plugins_dir,
	    recurse => true,
	    source  => "puppet:///modules/nagios/custom_plugins";
    }

    if ($operatingsystem == "CentOS" or $operatingsystem == "RedHat") {
	if ($os['selinux']['enabled']) {
	    File["Install Nagios custom plugins"]
		~> Exec["Restores Nagios Plugins SELinux attributes"]
	}
    }
}
