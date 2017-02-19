class opendkim::filetraq {
    $conf_dir = $opendkim::vars::conf_dir

    filetraq::define::trac {
	"opendkim":
	     pathlist =>
		[
		    "$conf_dir/opendkim.conf",
		    "$conf_dir/dkim.d/KeyTable",
		    "$conf_dir/dkim.d/SigningTable",
		    "$conf_dir/dkim.d/TrustedHosts"
		];
    }
}
