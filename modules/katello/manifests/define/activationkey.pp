define katello::define::activationkey($collections = false,
				      $contents    = false,
				      $contentview = 'Default Organization View',
				      $ensure      = 'present',
				      $hasrepos    = false,
				      $lce         = 'Library',
				      $org         = $katello::vars::katello_org) {
    if ($ensure == 'present') {
	exec {
	    "Install Activation-Key $name":
		command     => "hammer activation-key create --name '$name' --organization '$org' --content-view '$contentview' --lifecycle-environment '$lce'",
		environment => [ 'HOME=/root' ],
		onlyif      => "hammer activation-key list --organization '$org'",
		path        => "/usr/bin:/bin",
		require     => File["Install hammer cli configuration"],
		unless      => "hammer activation-key info --name '$name' --organization '$org'";
	    "Fix Activation-Key $name Content-View":
		command     => "hammer activation-key update --name '$name' --organization '$org' --content-view '$contentview'",
		environment => [ 'HOME=/root' ],
		path        => "/usr/bin:/bin",
		require     => Exec["Install Activation-Key $name"],
		unless      => "hammer activation-key info --name '$name' --organization '$org' | awk '/Content View:/{print \$3}' | grep '$contentview'";
	    "Fix Activation-Key $name Lifecycle Environment":
		command     => "hammer activation-key update --name '$name' --organization '$org' --lifecycle-environment '$lce'",
		environment => [ 'HOME=/root' ],
		path        => "/usr/bin:/bin",
		require     => Exec["Install Activation-Key $name"],
		unless      => "hammer activation-key info --name '$name' --organization '$org' | awk '/Lifecycle Environment:/{print \$3}' | grep '$lce'";
	}

	if ($collections != false and $collections != "") {
	    each($collections) |$col| {
		exec {
		    "Add Host-Collection $col to Activation-Key $name":
			command     => "hammer activation-key add-host-collection --name '$name' --organization '$org' --host-collection '$col'",
			environment => [ 'HOME=/root' ],
			path        => "/usr/bin:/bin",
			require     =>
			    [
				Exec["Install Activation-Key $name"],
				Katello::Define::Hostcollection[$col]
			    ],
			unless      => "hammer activation-key info --name '$name' --organization '$org' | grep '$col'";
		}
	    }
	}

	if ($hasrepos != false and $hasrepos != "") {
	    each($hasrepos) |$rp| {
		exec {
		    "Enable Repository $rp on systems registered through Activation-Key $name":
			command     => "hammer activation-key content-override --name '$name' --content-label '$rp' --value 1 --organization '$org'",
			environment => [ 'HOME=/root' ],
			path        => "/usr/bin:/bin",
			require     =>
			    [
				Exec["Install Activation-Key $name"],
				Katello::Define::Hostcollection[$col]
			    ],
			unless      => "hammer activation-key product-content --name '$name' --organization '$org' | grep '$rp' | grep yes";
		}
	    }
	}

	if ($katello_subscriptions != nil and $katello_subscriptions != "" and $contents != false) {
	    each($katello_subscriptions.split(',')) |$subid| {
		$subdata = "katello_subscription_$subid"
		$product = inline_template("<%=scope.lookupvar(@subdata)%>")
		each($contents) |$ctt| {
		    if ($product == $ctt) {
			exec {
			    "Add $product subscription to Activation-Key $name":
				command     => "hammer activation-key add-subscription --name '$name' --organization '$org' --subscription-id '$subid'",
				environment => [ 'HOME=/root' ],
				path        => "/usr/bin:/bin",
				require     => Exec["Install Activation-Key $name"],
				unless      => "hammer activation-key subscriptions --name '$name' --organization '$org' | grep -E '^[ ]*$subid '";
			}

			if (! ($product =~ /Red[ ]*Hat/ or $ctt =~ /Red[ ]*Hat/)) {
			    Katello::Define::Product[$product]
				-> Exec["Add $product subscription to Activation-Key $name"]
			}
		    }
		}
	    }
	}

	if ($contentview != 'Default Organization View') {
	    Katello::Define::Contentview[$contentview]
		-> Exec["Install Activation-Key $name"]
	}

	if ($lce != 'lce') {
	    Katello::Define::Lifecycleenvironment[$lce]
		-> Exec["Install Activation-Key $name"]
	}
    } else {
	exec {
	    "Drop Activation-Key $name":
		command     => "hammer activation-key delete --name '$name' --organization '$org'",
		environment => [ 'HOME=/root' ],
		onlyif      => "hammer activation-key info --name '$name' --organization '$org'",
		path        => "/usr/bin:/bin",
		require     => File["Install hammer cli configuration"];
	}
    }
}
