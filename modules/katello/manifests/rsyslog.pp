class katello::rsyslog {
    if ($apache::vars::apache_rsyslog == true) {
	include apache::rsyslog

	Exec["Reload Katello Services"]
	    -> Class["apache::rsyslog"]
    }
}
