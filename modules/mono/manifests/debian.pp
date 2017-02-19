class mono::debian {
    apt::define::aptkey {
	"xamarin":
	    keyid => "3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF";
    }

    apt::define::repo {
	"mono":
	    baseurl  => "http://download.mono-project.com/repo/debian",
	    codename => "wheezy", #single actual distro listed in dists
	    require  => Apt::Define::Aptkey["xamarin"];
    }

    common::define::package {
	"mono-devel":
	    require =>
		[
		    Apt::Define::Repo["mono"],
		    Exec["Update APT local cache"]
		];
    }
}
