class spamassassin::register {
    $conf_dir = $spamassassin::vars::conf_dir
    $routeto  = $spamassassin::vars::routeto

    Ssh_authorized_key <<| tag == $routeto |>>

    @@common::define::lined {
	"Register $fqdn to spamassassin sa-learn-cyrus":
	    line    => $fqdn,
	    path    => "$conf_dir/sa-learn-propagate.list",
	    require => File["Prepare sa-learn-propagate host list"],
	    tag     => "spamassassin-sa-learn";
    }
}
