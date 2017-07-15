class haproxy::custom {
    file {
	"Install HAproxy error messages":
	    group   => lookup("gid_zero"),
	    ignore  => [ ".svn", ".git" ],
	    owner   => root,
	    path    => $haproxy::vars::errors_dir,
	    recurse => true,
	    require => File["Prepare HAproxy for further configuration"],
	    source  => "puppet:///modules/nginx/error";
    }
}
