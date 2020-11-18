define tftpd::define::ks_centos($autopart = false,
				$rhelarch = "x86_64",
				$rhelvers = "8",
				$server   = false) {
    $charset      = $tftpd::vars::charset
    $password     = $tftpd::vars::default_pass
    $locale       = $tftpd::vars::locale_long
    $ntp_upstream = $tftpd::vars::ntp_upstream
    $ppmaster     = $tftpd::vars::puppetmaster
    $root_dir     = $tftpd::vars::root_dir
    $timezone     = $tftpd::vars::timezone

    if ($autopart) { $kssuffix = "-auto.ks" } else { $kssuffix = ".ks" }
    if ($server) { $hosttype = "server" } else { $hosttype = "desktop" }
    if ($tftpd::vars::dns_ip) { $dns_one = $tftpd::vars::dns_ip[0] }
    else { $dns_one = "8.8.8.8" }
    if ($tftpd::vars::squid_ip) {
	$use_proxy = " --proxy=http://proxy.$domain:3128"
    } else { $use_proxy = "" }
    $basepath = "$root_dir/ks/centos"

    file {
	"Install centos${rhelvers}-${rhelarch}_$hosttype$kssuffix":
	    content => template("tftpd/ks-centos.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "$basepath${rhelvers}-${rhelarch}_$hosttype$kssuffix",
	    require => File["Prepare kickstart directory"];
    }
}
