class kvm::modeles {
    $fsopts       = $kvm::vars::modeles_fsopts
    $nas          = $kvm::vars::modeles_nas
    $modeles_path = $kvm::vars::modeles_path

    if ($nas and $nas != $fqdn) {
	autofs::define::mount {
	    "kvm":
		fsopts      => $fsopts,
		remotepoint => "$nas:$modeles_path/kvm";
	}
    } elsif ($nas == $fqdn) {
	autofs::define::mount {
	    "kvm":
		mountstatus  => "disabled";
	}

	file {
	    "Link $modeles_path/kvm to local modeles":
		ensure => link,
		force  => true,
		path   => "/media/kvm",
		target => "$modeles_path/kvm";
	}
    }
}
