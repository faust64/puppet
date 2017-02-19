class docker::debian {
    if (! defined(Apt::Define::Repo["backports"])) {
	apt::define::repo {
	    "backports":
		branches => "main contrib non-free",
		codename => "${lsbdistcodename}-backports";
	}
    }

    common::define::package {
	"docker.io":
	    require =>
		[
		    Apt::Define::Repo["backports"],
		    Exec["Update APT local cache"]
		];
    }
}
