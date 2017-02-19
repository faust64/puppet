class jenkins::debian {
    apt::define::aptkey {
	"Kohsuke Kawaguchi":
	    url => "http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key";
    }

    apt::define::repo {
	"jenkins":
	    baseurl  => "http://pkg.jenkins-ci.org/debian",
	    branches => "binary/",
	    codename => "",
	    require  => Apt::Define::Aptkey["Kohsuke Kawaguchi"];
    }

    common::define::package {
	"jenkins":
	    require =>
		[
		    Apt::Define::Repo["jenkins"],
		    Exec["Update APT local cache"]
		];
    }

    Common::Define::Package["jenkins"]
	-> Common::Define::Service["jenkins"]
}
