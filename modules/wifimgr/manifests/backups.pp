class wifimgr::backups {
    file {
	"Prepare UniFi configuration dump directory":
	    ensure => directory,
	    group  => hiera("gid_zero"),
	    mode   => "0710",
	    owner  => root,
	    path   => $wifimgr::vars::dumpdir;
    }

    cron {
	"Backup UniFi local configuration":
	    command => "/usr/local/sbin/unifi_backup >/dev/null 2>&1",
	    ensure  => absent,
#{ "data" : [ ] , "meta" : { "msg" : "api.err.NoSuchCommand" , "rc" : "error"}
#je trouve pas l'info sur leur site, mais je commence a soupconner qu'il faille utiliser unifi-beta...
	    hour    => 23,
	    minute  => 12,
	    require => File["Install UniFi configuration backup script"],
	    user    => root;
    }
}
