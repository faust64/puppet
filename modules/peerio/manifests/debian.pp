class peerio::debian {
    $apt_repo     = $peerio::vars::apt_repo
    $apt_repo_key = $peerio::vars::apt_repo_key

    if (! defined(Apt::Define::Aptkey[$apt_repo_key])) {
	apt::define::aptkey {
	    $apt_repo_key:
		url => "$apt_repo/public.key";
	}
    }

    if (! defined(Apt::Define::Repo["peerio"])) {
	apt::define::repo {
	    "peerio-backend":
		baseurl  => $apt_repo,
		codename => "oldbear",
		require  => Apt::Define::Aptkey[$apt_repo_key];
	}
    }

    common::define::package {
	"peerio-backend":
	    require => Apt::Define::Repo["peerio-backend"];
    }

    Common::Define::Package["peerio-backend"]
	-> File["Prepare Peerio for further configuration"]
}
