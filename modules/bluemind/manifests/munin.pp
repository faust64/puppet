class bluemind::munin {
    file {
	"Links bm-elasticsearch to /var/lib/elasticsearch":
	    ensure => link,
	    path   => "/var/lib/elasticsearch",
	    source => "/var/spool/bm-elasticsearch";
    }

    include elasticsearch::vars
    include elasticsearch::munin

    include memcache::vars
    include memcache::munin

    include nginx::vars
    include nginx::munin
}
