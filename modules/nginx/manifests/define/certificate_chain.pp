define nginx::define::certificate_chain($server_certificate       = "server.crt",
					$server_certificate_chain = "server-chain.crt",
					$server_certificate_full  = "server-full.crt",
					$certificate_path         = false) {
    if ($certificate_path) {
	$look = $certificate_path
    }
    else {
	$conf_dir = $nginx::vars::conf_dir
	$look     = "$conf_dir/ssl"
    }

    exec {
	"Concatenate certificate chain and server certificate into $name":
	    command  => "cat $look/$server_certificate $look/$server_certificate_chain >$server_certificate_full",
	    cwd      => $look,
	    notify   => Service["nginx"],
	    onlyif   => "test -s $look/$server_certificate -a -s $look/$server_certificate_chain",
	    path     => "/usr/bin:/bin",
	    require  => File["Prepare nginx ssl directory"],
	    unless   => "test -s $server_certificate_full";
    }
}
