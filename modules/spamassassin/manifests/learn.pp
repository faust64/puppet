class spamassassin::learn {
    $conf_dir          = $spamassassin::vars::conf_dir
    $cyrus_domain_root = $spamassassin::vars::cyrus_domain_root
    $cyrus_ipurge      = $spamassassin::vars::cyrus_ipurge

    file {
	"Install sa-learn-cyrus configuration":
	    content => template("spamassassin/sa-learn.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "$conf_dir/sa-learn-cyrus.conf",
	    require => File["Prepare spamassassin for further configuration"];
	"Install sa-learn-cyrus script":
	    group   => hiera("gid_zero"),
	    mode    => "0750",
	    owner   => root,
	    path    => "/usr/local/sbin/sa-learn-cyrus",
	    source  => "puppet:///modules/spamassassin/sa-learn-cyrus",
	    require => File["Install sa-learn-cyrus configuration"];
    }
}
