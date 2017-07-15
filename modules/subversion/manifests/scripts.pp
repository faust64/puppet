class subversion::scripts {
    file {
	"Install svn_history_of_file script":
	    group  => lookup("gid_zero"),
	    mode   => "0755",
	    owner  => root,
	    path   => "/usr/local/bin/svn_history_of_file",
	    source => "puppet:///modules/subversion/history_of_file";
    }
}
