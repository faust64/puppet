class spamassassin::push {
    $conf_dir = $spamassassin::vars::conf_dir
    $contact  = $spamassassin::vars::contact

    file {
	"Install wrap-learn script":
	    content => template("spamassassin/wrap-learn.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0750",
	    owner   => root,
	    path    => "/usr/local/sbin/wrap-learn",
	    require => File["Install sa-learn-cyrus script"];
	"Prepare sa-learn-propagate host list":
	    content => "",
	    group   => hiera("gid_zero"),
	    mode    => "0640",
	    owner   => root,
	    path    => "$conf_dir/sa-learn-propagate.list",
	    replace => no,
	    require => File["Prepare spamassassin for further configuration"];
    }

    cron {
	"Propagate spamassassin bayes databases":
	    command => "/usr/local/sbin/wrap-learn >/dev/null 2>&1",
	    hour    => "22",
	    minute  => "18",
	    require =>
		[
		    File["Install wrap-learn script"],
		    File["Prepare sa-learn-propagate host list"]
		],
	    user    => root;
    }
}
