class certbot::config {
    $apache_dir          = $certbot::vars::apache_dir
    $apache_service_name = $certbot::vars::apache_service_name
    $contact             = $certbot::vars::contact
    $nginx_dir           = $certbot::vars::nginx_dir
    $postfix_dir         = $certbot::vars::postfix_dir
    $slack_hook          = $certbot::vars::slack_hook

    file {
	"Install Certbot renewal script":
	    content => template("certbot/renew.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0750",
	    owner   => root,
	    path    => "/usr/local/sbin/le_renew";
	"Purge Certbot daily renewal script":
	    ensure  => absent,
	    path    => "/etc/cron.d/certbot";
    }
}
