class asterisk::jobs {
    cron {
	"Check and reload local trunks":
	    command => "/usr/local/sbin/check_trunks >/dev/null 2>&1",
	    hour    => "7-21",
	    minute  => "*/5",
	    require =>
		[
		    File["Install asterisk trunks reloading main script"],
		    File["Install asterisk sip trunk reloading script"],
		    File["Install asterisk iax trunk reloading script"]
		],
	    user    => root;
	"Regenerate Aastra directory":
	    command => "/usr/local/sbin/aastra_directory >/dev/null 2>&1",
	    hour    => 11,
	    minute  => 12,
	    require => File["Install Aastra directory generation script"],
	    user    => root;
    }
}
