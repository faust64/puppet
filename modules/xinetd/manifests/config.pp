class xinetd::config {
    $clients = $xinetd::vars::clients

    file {
	"Prepare Xinetd for further configuration":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "/etc/xinetd.d";
	"Install Xinetd main configuration":
	    content => template("xinetd/xinetd.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    notify  => Service["xinetd"],
	    owner   => root,
	    path    => "/etc/xinetd.conf",
	    require => File["Prepare Xinetd for further configuration"];
    }
}
