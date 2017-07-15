class subsonic::collect {
    file {
	"Prepare subsonic remotes directory":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0750",
	    owner   => root,
	    path    => "/var/subsonic/remotes",
	    require => File["Install subsonic.properties"];
    }

    Common::Define::Lined <<| tag == "fingerprint-root-subsonic" |>>
    File <<| tag == "subsonic-sync-libraries" |>>
}
