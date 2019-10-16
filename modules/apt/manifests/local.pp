class apt::local {
    $repo = $apt::vars::apt_repo
    $rkey = $apt::vars::apt_repo_key

    if (! defined(Apt::Define::Aptkey[$rkey])) {
	apt::define::aptkey {
	    $rkey:
		url => "$repo/public.key";
	}
    }

    apt::define::repo {
	"UTGB":
	    baseurl => "$repo/",
	    require => Apt::Define::Aptkey[$rkey];
    }

    if ($architecture == "armv6l") {
# assuming all hosts announcing such architecture are RPI
# would have to check guru/sheeva plugs at least
	apt::define::repo {
	    "collabora":
		baseurl  => "http://raspberrypi.collabora.com",
		branches => "rpi";
	    "raspi":
		baseurl  => "http://archive.raspberrypi.org/debian/";
	    "wolfram":
		baseurl  => "http://repository.wolfram.com/raspbian/",
		branches => "non-free",
		codename => "stable";
	}
    }
}
