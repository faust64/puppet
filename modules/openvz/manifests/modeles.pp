class openvz::modeles {
    $fsopts       = $openvz::vars::modeles_fsopts
    $nas          = $openvz::vars::modeles_nas
    $modeles_path = $openvz::vars::modeles_path

    if ($nas and $nas != $fqdn) {
	autofs::define::mount {
	    "openvz":
		fsopts      => $fsopts,
		remotepoint => "$nas:$modeles_path/openvz";
	}
    } elsif ($nas == $fqdn) {
	autofs::define::mount {
	    "openvz":
		mountstatus  => "disabled";
	}

	file {
	    "Link $modeles_path/openvz to local modeles":
		ensure => link,
		force  => true,
		path   => "/media/openvz",
		target => "$modeles_path/openvz";
	}
    }
}
