class katello::config::custrepos {
    katello::define::product {
	"UTGB":
	    description => "UTGB custom assets";
    }

    katello::define::repository {
	"Airsonic deb":
	    product   => "UTGB",
	    shortname => "airsonic-deb",
	    type      => "deb",
	    url       => "offline";
	"EmbyServer deb":
	    product   => "UTGB",
	    shortname => "embyserver-deb",
	    type      => "deb",
	    url       => "offline";
	"PlexMediaServer deb":
	    product   => "UTGB",
	    shortname => "plexmediaserver-deb",
	    type      => "deb",
	    url       => "offline";
	"Subsonic deb":
	    product   => "UTGB",
	    shortname => "subsonic-deb",
	    type      => "deb",
	    url       => "offline";
	"Registry":
	    product   => "UTGB",
	    shortname => "registry",
	    type      => "docker",
	    url       => "offline";
    }
}
