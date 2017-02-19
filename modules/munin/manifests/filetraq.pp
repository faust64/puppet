class munin::filetraq {
    $conf_dir = $munin::vars::munin_conf_dir

    filetraq::define::trac {
	"munin":
	    pathlist =>
		[
		    "$conf_dir/munin-conf.d",
		    "$conf_dir/plugin-conf.d"
		];
    }
}
