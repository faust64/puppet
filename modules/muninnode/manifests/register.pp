class muninnode::register {
    $listen = $muninnode::vars::remoteaddr
    $port   = $muninnode::vars::remoteport

    @@file {
	"Munin Registration of $fqdn":
	    content => template("muninnode/munin.erb"),
	    mode    => "0644",
	    owner   => root,
	    path    => "/etc/munin/munin-conf.d/$fqdn",
	    require => File["Prepare munin supervised hosts directory"],
	    tag     => "munin-$domain";
    }
}
