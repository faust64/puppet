define logstash::define::plugin($verify = true) {
    $version = $logstash::vars::version
    $rootdir = $logstash::vars::installpath

    if (versioncmp($version, '2.3') < 0) {
	$command = "plugin"
    } else {
	$command = "logstash-plugin"
    }
    if (! defined(Exec["Install Logstash $name plugin"])) {
	if ($verify) {
	    $opts = ""
	} else {
	    $opts = " --no-verify"
	}

	exec {
	    "Install Logstash $name plugin":
		command     => "$command install$opts $name",
		cwd         => $rootdir,
		notify      => Exec["Mark Logstash $name plugin installed"],
		path        => "$rootdir/bin:/usr/local/sbin:/usr/sbin:/sbin:/usr/local/bin:/usr/bin:/bin",
		require     => File["Prepare logstash for further configuration"],
		unless      => "grep $name /root/logstash_plugins";
	    "Mark Logstash $name plugin installed":
		command     => "echo $name >>logstash_plugins",
		cwd         => "/root",
		notify      => Service["logstash"],
		path        => "/usr/bin:/bin",
		refreshonly => true;
	}
    }
}
