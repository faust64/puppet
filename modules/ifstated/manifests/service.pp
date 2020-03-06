class ifstated::service {
    exec {
	"Reload Ifstated configuration":
	    command     => "ifstated_resync",
	    cwd         => "/",
	    path        => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
	    refreshonly => true,
	    require     =>
		[
		    File["Ifstated application script"],
		    Common::Define::Lined["Enable Ifstated on boot"]
		];
    }
}
