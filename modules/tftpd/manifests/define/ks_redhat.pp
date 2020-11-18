define tftpd::define::ks_redhat($autopart = false,
				$rhelarch = "x86_64",
				$rhelvers = "8.3",
				$server   = false) {
    $charset      = $tftpd::vars::charset
    $password     = $tftpd::vars::default_pass
    $locale       = $tftpd::vars::locale_long
    $ntp_upstream = $tftpd::vars::ntp_upstream
    $ppmaster     = $tftpd::vars::puppetmaster
    $rhrepo       = $tftpd::vars::rhrepo
    $rhroot       = $tftpd::vars::rhroot
    $root_dir     = $tftpd::vars::root_dir
    $sdist        = split("$rhelvers", '\.')[0]
    $timezone     = $tftpd::vars::timezone

    if ($autopart) { $kssuffix = "-auto.ks" } else { $kssuffix = ".ks" }
    if ($server) { $hosttype = "server" } else { $hosttype = "desktop" }
    if ($tftpd::vars::dns_ip) { $dns_one = $tftpd::vars::dns_ip[0] }
    else { $dns_one = "8.8.8.8" }
    if ($tftpd::vars::squid_ip) {
	$use_proxy = " --proxy=http://proxy.$domain:3128"
    } else { $use_proxy = "" }
    $basepath = "$root_dir/ks/redhat"

    file {
	"Install redhat${rhelvers}-${rhelarch}_$hosttype$kssuffix":
	    content => template("tftpd/ks-redhat.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "$basepath${rhelvers}-${rhelarch}_$hosttype$kssuffix",
	    require => File["Prepare kickstart directory"];
    }
}
