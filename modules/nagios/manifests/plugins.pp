class nagios::plugins {
    file {
	"Install Nagios custom plugins":
	    group   => hiera("gid_zero"),
	    ignore  => [ ".svn", ".git" ],
	    mode    => "0755",
	    owner   => root,
	    path    => $nagios::vars::nagios_plugins_dir,
	    recurse => true,
	    source  => "puppet:///modules/nagios/custom_plugins";
    }
}
