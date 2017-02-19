class auditd::filetraq {
    $conf_dir    = $auditd::vars::conf_dir
    $plugins_dir = $auditd::vars::plugins_conf_dir

    filetraq::define::trac {
	"auditd":
	     pathlist =>
		[
		    "$conf_dir/*",
		    "$plugins_dir/*",
		    "$plugins_dir/*/*"
		];
    }
}
