class apt {
    include apt::vars
    include apt::filetraq
    include apt::jobs
    include apt::local
    include apt::logrotate
    include apt::scripts
    include apt::service

    if ($apt::vars::apt_proxy == $fqdn) {
	include apt::config
    } else {
	class {
	    apt::config:
		stage => "chenille";
	}
    }
}
