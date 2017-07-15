class munin::scripts {
    file {
	"Install munin-cron script":
	    group  => lookup("gid_zero"),
	    mode   => "0755",
	    owner  => root,
	    path   => "/usr/bin/munin-cron",
	    source => "puppet:///modules/munin/munin-cron";
	"Install munin-graph script":
	    group  => lookup("gid_zero"),
	    mode   => "0755",
	    owner  => root,
	    path   => "/usr/bin/munin-graph",
	    source => "puppet:///modules/munin/munin-graph";
    }
}
