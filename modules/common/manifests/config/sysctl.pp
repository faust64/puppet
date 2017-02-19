class common::config::sysctl {
    file {
	"Ensure sysctl.conf present":
	    content => "",
	    group   => hiera("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "/etc/sysctl.conf",
	    replace => no;
    }
}
