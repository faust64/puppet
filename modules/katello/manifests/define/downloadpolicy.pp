define katello::define::downloadpolicy($kind = 'immediate') {
    exec {
	"Set Katello Download Policy":
	    command     => "hammer settings set --name default_download_policy --value $kind",
	    environment => [ 'HOME=/root' ],
	    path        => "/usr/bin:/bin",
	    require     => File["Install hammer cli configuration"],
	    unless      => "hammer settings list | grep default_download_policy | awk -F'|' '{print \$3}' | grep $kind";
	"Set Katello-Proxy Download Policy":
	    command     => "hammer settings set --name default_proxy_download_policy --value $kind",
	    environment => [ 'HOME=/root' ],
	    path        => "/usr/bin:/bin",
	    require     => File["Install hammer cli configuration"],
	    unless      => "hammer settings list | grep default_proxy_download_policy | awk -F'|' '{print \$3}' | grep $kind";
    }
}
