class ossec::register {
    $conf_dir = $ossec::vars::conf_dir
    $manager  = $ossec::vars::manager

    exec {
	"OSSEC register to $manager":
	    command => "$conf_dir/bin/agent-auth -m $manager -A $fqdn -p 1515 -D $conf_dir",
	    creates => "$conf_dir/etc/client.keys",
	    cwd     => "/",
	    path    => "/usr/bin:/bin";
    }

    Exec["OSSEC register to $manager"]
	-> Common::Define::Service[$ossec::vars::service_name]
}
