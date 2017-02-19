class mrtg::jobs {
    exec {
	"Register local switches":
	    command     => "/usr/local/bin/mrtg_register_sw",
	    cwd         => "/",
	    path        => "/usr/bin:/bin",
	    refreshonly => true,
	    require     => File["Install mrtg switches registration script"];
    }

    cron {
	"Update mrtg graphs":
	    command => "/usr/local/bin/mrtgupdate >/dev/null 2>&1",
	    minute  => "*/2",
	    require => File["Install mrtg update script"],
	    user    => root;
	"Archive mrtg graphs":
	    command => "/usr/local/bin/mrtgarchive >/dev/null 2>&1",
	    minute  => 42,
	    hour    => "*/6",
	    require => File["Install mrtg archive script"],
	    user    => root;
	"Archive weathermap graphs":
	    command => "/usr/local/bin/wmaparchive >/dev/null 2>&1",
	    minute  => "*/5",
	    require => File["Install wmap archive script"],
	    user    => root;
    }
}
