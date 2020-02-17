class airsonic::collect {
    file {
	"Prepare airsonic remotes directory":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0750",
	    owner   => root,
	    path    => "/var/airsonic/remotes",
	    require => File["Install airsonic.properties"];
    }

    Common::Define::Lined <<| tag == "fingerprint-root-airsonic" |>>
    File <<| tag == "airsonic-sync-libraries" |>>
}
