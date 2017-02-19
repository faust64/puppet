class bluemind {
    include bluemind::vars

    include opendkim
    include spamassassin
    if ($bluemind::vars::do_letsencrypt) {
	include certbot
    }

    include bluemind::collect
    include bluemind::logrotate
    include bluemind::rsyslog
}
