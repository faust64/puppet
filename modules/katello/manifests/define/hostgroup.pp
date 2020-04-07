define katello::define::hostgroup($ak           = false,
				  $arch         = false,
				  $cv           = false,
				  $description  = "$name hosts",
				  $env          = false,
				  $ensure       = 'present',
				  $domain       = false,
				  $os           = false,
				  $ks           = "Kickstart default",
				  $lifecycleenv = false,
				  $medium       = "CentOS mirror",
				  $subnet       = false,
				  $org          = $katello::vars::katello_org,
				  $scap_capsule = false) {
    if ($ensure == 'present') {
	if ($domain != false) {
	    Katello::Define::Domain[$domain]
		-> Exec["Install Host-Group $name"]

	    $dom = " --domain $domain"
	} else { $dom = "" }
	if ($subnet != false) {
	    Katello::Define::Subnet[$subnet]
		-> Exec["Install Host-Group $name"]

	    $sn = " --subnet $subnet"
	} else { $sn = "" }
	if ($lifecycleenv != false) {
	    Katello::Define::Lifecycleenvironment[$lifecycleenv]
		-> Exec["Install Host-Group $name"]

	    $lce = " --lifecycle-environment $lifecycleenv"
	} else { $lce = " --lifecycle-environment Library" }
	if ($cv != false) {
	    Katello::Define::Contentview[$cv]
		-> Exec["Install Host-Group $name"]

	    $mcv = " --content-view $cv"
	} else { $mcv = "" }

	if ($scap_capsule != false) {
	    $scap = " --openscap-proxy $scap_capsule"
	} else { $scap = " --openscap-proxy-id 1" }
	if ($os != false) {
	    $mos = " --operatingsystem '$os'"
	} else { $mos = "" }
	if ($ks != false) {
	    if ($ks != "Kickstart default") {
		Exec["Install Katello $ks"]
		    -> Exec["Install Host-Group $name"]
	    }

	    $pw     = $katello::vars::ks_password
	    $ptable = " --partition-table '$ks' --medium '$medium' --root-pass '$pw'"
	} else { $ptable = "" }
	if ($arch != false) {
	    $march = " --architecture $arch"
	} else { $march = " --architecture x86_64" }
	if ($env != false) {
	    $menv = " --puppet-environment $env"
	} else { $menv = " --puppet-environment-id 1" }
	if ($description != false) {
	    $mdescr = " --description '$description'"
	} else { $mdescr = "" }
	$ppmaster       = $katello::vars::puppet_master
	$cmdargs        = [ "hammer hostgroup create --name '$name'$march",
			    "--organization '$org'$scap$dom$sn$mos$menv",
			    "--query-organization '$org'$ptable$lce$mcv",
			    "--content-source-id 1$mdescr" ]
	$setcaattrs     = [ "hammer hostgroup set-parameter --hostgroup '$name'",
			    "--name=external_puppet_ca --value=$ppmaster",
			    "--parameter-type=string" ]
	$setpuppetattrs = [ "hammer hostgroup set-parameter --hostgroup '$name'",
			    "--name=external_puppet_server --value=$ppmaster",
			    "--parameter-type=string" ]

	exec {
	    "Install Host-Group $name":
		command     => $cmdargs.join(' '),
		environment => [ 'HOME=/root' ],
		onlyif      => "hammer hostgroup list --organization '$org'",
		path        => "/usr/bin:/bin",
		require     => File["Install hammer cli configuration"],
		unless      => "hammer hostgroup info --name '$name' --organization '$org'";
	    "Sets Host-Group $name Puppet-Server Attribute":
		command     => $setpuppetattrs.join(' '),
		environment => [ 'HOME=/root' ],
		path        => "/usr/bin:/bin",
		require     => Exec["Install Host-Group $name"],
		unless      => "hammer hostgroup info --name '$name' --organization '$org' | grep 'external_puppet_server .*=> .*$external_puppet_server'";
	    "Sets Host-Group $name Puppet-CA Attribute":
		command     => $setcaattrs.join(' '),
		environment => [ 'HOME=/root' ],
		path        => "/usr/bin:/bin",
		require     => Exec["Install Host-Group $name"],
		unless      => "hammer hostgroup info --name '$name' --organization '$org' | grep 'external_puppet_ca .*=> .*$external_puppet_ca'";
	}

	if ($ak != false) {
	    $akattrs = [ "hammer hostgroup set-parameter --hostgroup '$name'",
			 "--name=kt_activation_keys --value=$ak",
			 "--parameter-type=string" ]
	    exec {
		"Sets Host-Group $name ActivationKey Attribute":
		    command     => $akattrs.join(' '),
		    environment => [ 'HOME=/root' ],
		    path        => "/usr/bin:/bin",
		    require     =>
			[
			    Exec["Install Host-Group $name"],
			    Katello::Define::Activationkey[$ak]
			],
		    unless      => "hammer hostgroup info --name '$name' --organization '$org' | grep 'kt_activation_keys .*=> .*$ak'";
	    }
	}
    } else {
	exec {
	    "Drop Host-Group $name":
		command     => "hammer hostgroup delete --name '$name' --organization '$org'",
		environment => [ 'HOME=/root' ],
		onlyif      => "hammer hostgroup info --name '$name' --organization '$org'",
		path        => "/usr/bin:/bin",
		require     => File["Install hammer cli configuration"];
	}
    }
}
