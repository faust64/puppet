class medusa::install {
    $home_dir = $medusa::vars::home_dir

    group {
	$medusa::vars::runtime_group:
	   ensure  => present;
    }

    user {
	$medusa::vars::runtime_user:
	    gid     => $medusa::vars::runtime_group,
	    require => Group[$medusa::vars::runtime_group];
    }

    git::define::clone {
	"medusa":
	    branch          => $medusa::vars::version,
	    grp             => $medusa::vars::runtime_group,
	    local_container => "/usr/share",
	    repository      => "https://github.com/pymedusa/Medusa",
	    require         => User[$runtime_user],
	    update          => false,
	    usr             => $medusa::vars::runtime_user;
    }

    python::define::requirements {
	"medusa":
	    requirements => "requirements.txt",
	    subscribe    => Git::Define::Clone["medusa"],
	    wd           => $home_dir;
    }

    Python::Define::Requirements["medusa"]
	-> Common::Define::Service["medusa"]
}
