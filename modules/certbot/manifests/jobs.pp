class certbot::jobs {
    if ($certbot::vars::renew_day and $certbot::vars::renew_hour and $certbot::vars::renew_min) {
	cron {
	    "Renew Certbot certificates":
		command  => "/usr/local/sbin/le_renew",
		hour     => $certbot::vars::renew_hour,
		minute   => $certbot::vars::renew_min,
		monthday => $certbot::vars::renew_day,
		require  => File["Install Certbot renewal script"],
		user     => root;
	}
    } else {
	notify { "patch needed: cerbot certificates renewal schedule not defined": }
    }
}
