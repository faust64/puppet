class kibana::config {
    $index   = $kibana::vars::index_name
    $listen  = $kibana::vars::esearch_listen
    $version = $kibana::vars::esearch_version

    file {
	"Prepare kibana for further configuration":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "/etc/kibana";
	"Install Kibana main configuration":
	    content => template("kibana/config.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    notify  => Service["kibana"],
	    owner   => root,
	    path    => "/etc/kibana/kibana.yml",
	    require => File["Prepare kibana for further configuration"];
    }
}
