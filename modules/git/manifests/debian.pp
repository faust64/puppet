class git::debian {
    common::define::package {
	"git":
    }

    if ($git::vars::with_gitlab == true) {
	exec {
	    "Install GitLab repository":
		command => "curl -sS https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.deb.sh",
		creates => "/etc/apt/sources.list.d/gitlab_gitlab-ce.list",
		notify  => Exec["Update APT local cache"],
		path    => "/usr/sbin:/usr/bin:/sbin:/bin";
	}

	common::define::package {
	    "gitlab-ce":
		require => Exec["Update APT local cache"];
	}
    }
}
