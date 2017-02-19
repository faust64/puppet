class spamassassin::filetraq {
    $conf_dir = $spamassassin::vars::conf_dir

    filetraq::define::trac {
	"spamassassin":
	     pathlist => [ "$conf_dir/local.cf" ];
    }
}
