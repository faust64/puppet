class bluemind::scripts {
    file {
	"Install BlueMind elasticsearch indexes fix":
	    source => "puppet:///modules/bluemind/fix-elasticsearch",
	    group  => lookup("gid_zero"),
	    mode   => "0750",
	    owner  => root,
	    path   => "/root/fix-elasticsearch";
	"Install BlueMind logs purge script":
	    source => "puppet:///modules/bluemind/logpurge",
	    group  => lookup("gid_zero"),
	    mode   => "0750",
	    owner  => root,
	    path   => "/usr/local/sbin/purge_bm_logs";
	"Install BlueMind replication cleanup script":
	    source => "puppet:///modules/bluemind/fix-replication",
	    group  => lookup("gid_zero"),
	    mode   => "0750",
	    owner  => root,
	    path   => "/usr/local/sbin/fix_bm_replication";
	"Install BlueMind telegraf fix":
	    source => "puppet:///modules/bluemind/fix-telegraf",
	    group  => lookup("gid_zero"),
	    mode   => "0750",
	    owner  => root,
	    path   => "/root/fix-telegraf";
    }
}
