class katello::config::basics {
    katello::define::downloadpolicy { "main": }
    katello::define::environment { "production": }
    katello::define::hostcollection { "Infra": }

    exec {
	"Import OpenSCAP Contents":
	    command     => "foreman-rake foreman_openscap:bulk_upload:default",
	    environment => [ 'HOME=/root' ],
	    path        => "/usr/bin:/bin",
	    require     => File["Install hammer cli configuration"],
	    unless      => "hammer scap-content list | grep -i firefox",
    }

    katello::define::globalparam {
	"Subscription Manager":
	    type  => "boolean",
	    value => "true",
	    var   => "subscription_manager";
    }

    if ($katello::vars::manifest) {
	common::define::geturl {
	    "Katello Manifest":
		target  => "/root/manifest.zip",
		noproxy => true,
		notify  => Exec["Import Katello Manifest"],
		url     => $katello::vars::manifest,
		wd      => "/tmp";
	}

	exec {
	    "Import Katello Manifest":
		command     => "hammer subscription upload --file ./manifest.zip --organization-id 1",
		cwd         => "/root",
		environment => [ 'HOME=/root' ],
		path        => "/usr/bin:/bin",
		refreshonly => true,
		require     => File["Install hammer cli configuration"];
	}
    }
}
