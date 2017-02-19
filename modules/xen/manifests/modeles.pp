class xen::modeles {
    $fsopts       = $xen::vars::modeles_fsopts
    $nas          = $xen::vars::modeles_nas
    $modeles_path = $xen::vars::modeles_path

    if ($nas and $nas != $fqdn) {
	autofs::define::mount {
	    "xen":
		fsopts      => $fsopts,
		remotepoint => "$nas:$modeles_path/xen";
	}
    } elsif ($nas == $fqdn) {
	autofs::define::mount {
	    "xen":
		mountstatus  => "disabled";
	}

	file {
	    "Link $modeles_path/xen to local modeles":
		ensure => link,
		force  => true,
		path   => "/media/xen",
		target => "$modeles_path/xen";
	}
    }
}
