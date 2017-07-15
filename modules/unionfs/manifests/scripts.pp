class unionfs::scripts {
    file {
	"Install mount_unionfs script":
	    group  => lookup("gid_zero"),
	    mode   => "0755",
	    owner  => root,
	    path   => "/usr/local/bin/mount_unionfs",
	    source => "puppet:///modules/unionfs/mount";
	"Install unionfs_commit script":
	    group  => lookup("gid_zero"),
	    mode   => "0750",
	    owner  => root,
	    path   => "/usr/local/sbin/commit_unionfs",
	    source => "puppet:///modules/unionfs/commit";
    }
}
