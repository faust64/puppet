class openldap::webapp {
    include php
    include apache

    if ($openldap::vars::web_front == "phpldapadmin") {
	apache::define::vhost {
	    "phpldapadmin.$domain":
		app_root      => "/usr/share/phpldapadmin",
		vhostldapauth => true;
	}
    } else {
	$keyphrase    = $openldap::vars::ssp_keyphrase
	$ldap_bind_dn = $openldap::vars::ssp_bind_dn
	$ldap_bind_pw = $openldap::vars::ssp_bind_pw
	$ldap_slave   = $openldap::vars::ldap_slave
	$mail_from    = $openldap::vars::ssp_mail_from
	$user_base    = $openldap::vars::ldap_suffix

	apache::define::vhost {
	    "sso.$domain":
		app_root      => "/usr/share/self-service-password",
		csp_name      => "ssp",
		vhostldapauth => true;
	}

#FIXME: need to install package via puppet / register package to our repo
#FIXME: then add require
#FIXME: also, permissions should be set as 640, owned by root:www-data
	file {
	    "Install Self-Service-Password main configuration":
		content => template("openldap/ssp.erb"),
		group   => lookup("gid_zero"),
		mode    => "0644",
		owner   => root,
		path    => "/usr/share/self-service-password/conf/config.inc.php";
	}
    }
}
