class wifimgr::profile {
    file {
	"Install UniFi profile configuration":
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "/etc/profile.d/unifi.sh",
	    require =>
		[
		    File["Install UniFi SH API script"],
		    File["Prepare Profile for further configuration"]
		],
	    source  => "puppet:///modules/wifimgr/profile";
    }
}
