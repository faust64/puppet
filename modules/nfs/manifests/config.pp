class nfs::config {
    file {
	"Install NFS exports":
	    content => "",
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "/etc/exports",
	    replace => no;
    }
}
