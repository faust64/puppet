class camtrace::profile {
    file {
	"Install camtrace profile configuration":
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "/etc/profile.d/camtrace.sh",
	    require => File["Prepare Profile for further configuration"],
	    source  => "puppet:///modules/camtrace/profile";
    }
}
