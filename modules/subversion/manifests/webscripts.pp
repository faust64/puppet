class subversion::webscripts {
    file {
	"Install new_svn script":
	    group  => lookup("gid_zero"),
	    mode   => "0755",
	    owner  => root,
	    path   => "/usr/local/bin/new_svn",
	    source => "puppet:///modules/subversion/new_svn";
    }
}
