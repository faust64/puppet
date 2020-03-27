class firewalld::service {
    common::define::service {
	"firewalld":
	    ensure => running;
    }

    exec {
	"Reload Firewalld configuration":
	    command     => "firewall-cmd --reload",
	    path        => "/usr/sbin:/usr/bin:/sbin:/bin",
	    refreshonly => true,
	    require     => Common::Define::Service["firewalld"];
    }
}
