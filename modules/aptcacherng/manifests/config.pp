class aptcacherng::config {
    $passphrase = $aptcacherng::vars::passphrase

    file {
	"Install apt-cacher-ng main configuration":
	    group   => lookup("gid_zero"),
	    ignore  => [ ".svn", ".git" ],
	    owner   => root,
	    path    => "/etc/apt-cacher-ng",
	    recurse => true,
	    source  => "puppet:///modules/aptcacherng/main";
	"Install apt-cacher-ng security configuration":
	    content => template("aptcacherng/security.erb"),
	    group   => apt-cacher-ng,
	    mode    => "0640",
	    notify  => Service["apt-cacher-ng"],
	    owner   => root,
	    path    => "/etc/apt-cacher-ng/security.conf",
	    require => File["Install apt-cacher-ng main configuration"];
    }
}
