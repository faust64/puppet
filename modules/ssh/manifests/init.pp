class ssh {
    include ssh::vars

    case $myoperatingsystem {
	"Debian", "Devuan", "Ubuntu": {
	    include ssh::debian
	}
	"CentOS", "RedHat": {
	    include ssh::rhel
	}
    }

    include ssh::config
    include ssh::service
    include ssh::localkey
    include ssh::authkey

    if ($kernel == "Linux") {
	include ssh::tcpwrappers
    }

    create_resources(ssh::define::set_keys, $ssh::vars::ssh_keys_database)
}
