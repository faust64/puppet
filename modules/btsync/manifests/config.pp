class btsync::config {
    file {
	"Prepare btsync for further configuration":
	    ensure  => directory,
	    group   => hiera("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "/etc/btsync";
	"Drop debian default btsync instance":
	    ensure  => absent,
	    force   => true,
	    notify  => Service["btsync"],
	    path    => "/etc/btsync/debconf-default.conf",
	    require => Package["btsync"];
	"Drop btsync sample instances":
	    ensure  => absent,
	    force   => true,
	    path    => "/etc/btsync/samples",
	    require => Package["btsync"];
    }
}
