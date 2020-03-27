class katello::client {
    if (! defined(Class["katello::vars"])) {
	include katello::vars
    }

    $ak           = $katello::vars::ak
    $org          = $katello::vars::katello_org
    $foreman_fqdn = $katello::vars::foreman_fqdn
    $foreman_url  = $katello::vars::foreman_url

    if ($foreman_fqdn and
	($operatingsystem == "CentOS" or $operatingsystem == "RedHat")) {
	if ($register_with and $ak) {
	    common::define::package {
		[ "katello-agent", "katello-host-tools", "katello-host-tools-tracer" ]:
		    require => Exec["Register against katello"];
	    }
	}

	common::define::package {
	    "katello-ca-consumer-$foreman_fqdn":
		require => Common::Define::Package["subscription-manager"],
		source  => "http://$foreman_fqdn/pub/katello-ca-consumer-latest.noarch.rpm";
	    "subscription-manager":
	}

	$deppkg        = "katello-ca-consumer-$foreman_fqdn"
	$proof         = "/usr/bin/katello-rhsm-consumer" #FIXME
	$register_with = "subscription-manager register"
    } elsif ($foreman_fqdn and
	($operatingsystem == "Debian" or $myoperatingsystem == "Devuan"
	 or $operatingsystem == "Ubuntu")) {
	common::define::package {
	    "deb-subscription":
		provider => "pip";
	}

	$deppkg        = "deb-subscription"
	$proof         = "FIXME" #FIXME
	$register_with = "deb_subscription --fqdn $foreman_fqdn"
    } else {
	$register_with = false
	$proof         = false
    }

    if ($register_with and $ak) {
	if ($org) {
	   $opts = " --organization '$org'"
	} else { $opts = "" }

	exec {
	    "Register against katello":
		command => "$register_with$opts --activationkey '$ak'",
		creates => $proof,
		path    => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin";
	}

	if ($deppkg) {
	    Common::Define::Package[$deppkg]
		-> Exec["Register against katello"]
	}
    }
}
