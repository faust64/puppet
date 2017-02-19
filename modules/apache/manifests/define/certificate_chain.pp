define apache::define::certificate_chain($server_certificate       = "server.crt",
					 $server_certificate_chain = "server-chain.crt",
					 $server_certificate_full  = "server-full.crt",
					 $certificate_path         = false) {
    if ($certificate_path) {
	$look = $certificate_path
    } else {
	$conf_dir = $apache::vars::conf_dir
	$look     = "$conf_dir/ssl"
    }

    exec {
	"Concatenate certificate chain and server certificate into $name":
	    command  => "cat $look/$server_certificate $look/$server_certificate_chain >$server_certificate_full",
	    cwd      => $look,
	    notify   => Service[$apache::vars::service_name],
	    onlyif   => "test -s $look/$server_certificate -a -s $look/$server_certificate_chain",
	    path     => "/usr/bin:/bin",
	    require  => File["Prepare apache ssl directory"],
	    unless   => "test -s $server_certificate_full";
	"Concatenate dh params to $name certificate":
	    command  => "cat $server_certificate_full dh.pem >dh$server_certificate_full",
	    cwd      => $look,
	    notify   => Service[$apache::vars::service_name],
	    onlyif   => "test -s $look/$server_certificate_full -a -s dh.pem",
	    path     => "/usr/bin:/bin",
	    require  =>
		[
		    Exec["Generate apache dh.pem"],
		    Exec["Concatenate certificate chain and server certificate into $name"]
		],
	    unless   => "test -s dh$server_certificate_full";
    }
}
