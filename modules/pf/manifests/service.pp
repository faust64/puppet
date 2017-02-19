class pf::service {
    exec {
	"Reload pf configuration":
	    command     => "pf_resync",
	    cwd         => "/",
	    path        => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
	    refreshonly => true,
	    require     => File["Pf application script"];
# Assuming enabling ruleset-optimizations, consider raising command timeout, ...
# pfctl -nf & pfctl -f might take around 4 minutes each
#	    timeout     => 600;
    }
}
