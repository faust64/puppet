class katello {
    include apache::vars
    include katello::vars
    include openldap::client

    include katello::rhel
    include katello::client
    include katello::config
    include katello::hammer
    include katello::profile
    include katello::rsyslog
    include katello::service

    include katello::config::auth
    include katello::config::basics
    include katello::config::custrepos
    include katello::config::firewalld
    include katello::config::lce
    include katello::config::network
    include katello::config::patches
    include katello::config::repos
    include katello::config::subs
    include katello::config::views

    if ($katello::vars::manifest) {
	include katello::config::rhrepos
	include katello::config::rhsubs
	include katello::config::rhviews
    }

    include katello::munin
    include katello::nagios
}
