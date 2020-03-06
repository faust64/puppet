define nfs::define::share($options = [ "ro" , "no_subtree_check",
					"root_squash", "async" ],
			  $path    = "/var/empty",
			  $to      = [ "127.0.0.0/8" ] ) {
    if (! defined(Class["nfs"])) {
	include nfs
    }

    $optstr = join($options, ',')
    $tostr  = join($to, ',')
    $allstr = regsubst($tostr, ',', "($optstr) ", 'G')
    $final  = "$allstr($optstr)"

    common::define::lined {
	"Set $name NFS share":
	    line    => "$path $final",
	    match   => $path,
	    notify  => Service[$nfs::vars::srvname],
	    path    => "/etc/exports",
	    require => File["Install NFS exports"];
    }
}
