class samba::nfs {
    $fsopts         = $samba::vars::samba_fsopts
    $samba_nfs_path = $samba::vars::samba_nfs_path
    $samba_over_nfs = $samba::vars::samba_over_nfs

    if ($samba_over_nfs) {
	include autofs

	autofs::define::mount {
	    "home":
		fsopts      => $fsopts,
		remotepoint => "$samba_over_nfs:$samba_nfs_path";
	}
    }
}
