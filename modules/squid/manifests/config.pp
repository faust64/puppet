class squid::config {
    $apt_cacher       = $squid::vars::apt_cacher
    $cache_mem        = $squid::vars::cache_mem
    $contact          = $squid::vars::contact_escalate
    $domain_blacklist = $squid::vars::acl_domainblacklist
    $hosts_blacklist  = $squid::vars::acl_blacklist
    $hosts_whitelist  = $squid::vars::acl_whitelist
    $ports_acl        = $squid::vars::acl_ports
    $conf_dir         = $squid::vars::conf_dir
    $cache_dir        = $squid::vars::cache_dir
    $error_dir        = $squid::vars::error_dir
    $locale           = $squid::vars::locale
    $localnet         = $squid::vars::localnet
    $log_dir          = $squid::vars::log_dir
    $max_object_size  = $squid::vars::cache_objsize_max
    $nocache          = $squid::vars::acl_domainnocache
    $rotate           = $squid::vars::rotate
    $runtime_group    = $squid::vars::runtime_group
    $wat_do           = $squid::vars::wat_do

    file {
	"Prepare Squid for further configuration":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => $conf_dir;
	"Prepare Squid cache directory":
	    ensure  => directory,
	    group   => $squid::vars::runtime_group,
	    mode    => "0771",
	    owner   => $squid::vars::runtime_user,
	    path    => $cache_dir;
	"Prepare Squid log directory":
	    ensure  => directory,
	    group   => $squid::vars::runtime_group,
	    mode    => "0771",
	    owner   => $squid::vars::runtime_user,
	    path    => $log_dir;

	"Install Squid main configuration":
	    content => template("squid/squid.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    notify  => Service[$squid::vars::service_name],
	    owner   => root,
	    path    => "$conf_dir/squid.conf",
	    require => File["Install Squid nocache ACL configuration"];
	"Install Squid nocache ACL configuration":
	    content => template("squid/nocache.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    notify  => Service[$squid::vars::service_name],
	    owner   => root,
	    path    => "$conf_dir/nocache.acl",
	    require => File["Prepare Squid for further configuration"];
    }
}
