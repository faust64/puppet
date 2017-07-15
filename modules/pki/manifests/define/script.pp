define pki::define::script() {
    file {
	"Install $name script":
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "/usr/local/bin/$name",
	    source  => "puppet:///modules/pki/bins/$name";
    }
}
