class hast::config {
    $resources = $hast::vars::resources

    file {
	"Install hast main configuration":
	    content => template("hast/hast.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0644",
	    notify  => Service["hastd"],
	    owner   => root,
	    path    => "/etc/hast.conf";
    }
}
