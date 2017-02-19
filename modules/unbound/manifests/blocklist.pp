class unbound::blocklist {
    $conf_dir = $unbound::vars::conf_dir
    $download = $unbound::vars::download

    file {
	"Install custom dns blacklist":
	    group   => hiera("gid_zero"),
	    mode    => "0644",
	    notify  => Exec["Regenerate unbound blocklist.conf"],
	    owner   => root,
	    path    => "/root/my_domains.txt",
	    require => File["Install blocklist generation script"],
	    source  => "puppet:///modules/unbound/dns_blacklist";
	"Install empty blocklist.conf":
	    content => "",
	    group   => hiera("gid_zero"),
	    mode    => "0644",
	    notify  => Exec["Regenerate unbound blocklist.conf"],
	    owner   => root,
	    path    => "$conf_dir/blocklist.conf",
	    replace => no;
    }

    exec {
	"Regenerate unbound blocklist.conf":
	    command     => "blocklist_gen",
	    cwd         => "/root",
	    notify      => Service["unbound"],
	    path        => "/usr/local/sbin:/usr/sbin:/sbin:/usr/local/bin:/usr/bin:/bin",
	    refreshonly => true;
    }

    File["Install blocklist generation script"]
	-> File["Install empty blocklist.conf"]
	-> Exec["Regenerate unbound blocklist.conf"]
}
