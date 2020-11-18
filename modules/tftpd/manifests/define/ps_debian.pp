define tftpd::define::ps_debian($autopart = false,
				$debvers  = "buster",
				$server   = false) {
    $apt_proxy    = $tftpd::vars::apt_proxy
    $charset      = $tftpd::vars::charset
    $locale       = $tftpd::vars::locale
    $locale_long  = $tftpd::vars::locale_long
    $ntp_upstream = $tftpd::vars::ntp_upstream
    $password     = $tftpd::vars::preseed_pass
    $ppmaster     = $tftpd::vars::puppetmaster
    $root_dir     = $tftpd::vars::root_dir
    $sysfamily    = "Debian"
    $timezone     = $tftpd::vars::timezone

    if ($server != false) { if ($server != true) { $ppfx = "-$server" } else { $ppfx = "" } } else { $ppfx = "" }
    if ($autopart) { $pssuffix = "$ppfx-auto.preseed" } else { $pssuffix = "$ppfx.preseed" }
    if ($server) { $hosttype = "server" } else { $hosttype = "desktop" }
    if ($tftpd::vars::dns_ip) { $dns_one = $tftpd::vars::dns_ip[0] }
    else { $dns_one = "8.8.8.8" }
    if ($tftpd::vars::squid_ip) {
	$use_proxy = " --proxy=http://proxy.$domain:3128"
    }
    else { $use_proxy = "" }
    $basepath = "$root_dir/preseed/$debvers"

    file {
	"Install debian ${debvers}_$hosttype$pssuffix":
	    content => template("tftpd/preseed.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "${basepath}_$hosttype$pssuffix",
	    require => File["Prepare preseed directory"];
    }
}
