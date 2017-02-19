class tftpd::scripts {
    $contact    = $tftpd::vars::contact
    $pxe_master = $tftpd::vars::pxe_master
    $root_dir   = $tftpd::vars::root_dir

    if ($pxe_master != false) {
	file {
	    "Install PXE repository update script":
		content => template("tftpd/update.erb"),
		group   => hiera("gid_zero"),
		mode    => "0750",
		owner   => root,
		path    => "/usr/local/sbin/repo_update";
	}
    } else {
	file {
	    "Drop PXE repository update script":
		ensure  => absent,
		force   => true,
		path    => "/usr/local/sbin/repo_update";
	}
    }
}
