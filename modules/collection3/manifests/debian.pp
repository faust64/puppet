class collection3::debian {
    $web_root = $collection3::vars::web_root

    if ($lsbdistcodename == "jessie") {
	file_line {
	    "Disable collection warnings from CGI::param":
		after   => "use HTML::Entities ('fatalsToBowser');",
		line    => '$CGI::LIST_CONTEXT_WARN = 0;',
		match   => '^$CGI::LIST_CONTEXT_WARN',
		path    => "$web_root/collection3/bin/index.cgi",
		require => Exec["Install collection site from collectd docs"];
	}
    }

    common::define::package {
	[ "libconfig-general-perl", "libregexp-common-perl", "libhtml-parser-perl" ]:
    }

    exec {
	"Install collection site from collectd docs":
	    command => "cp -rp /usr/share/doc/collectd/examples/collection3 $web_root/",
	    creates => "$web_root/collection3",
	    path    => "/usr/bin:/bin",
	    require =>
		[
		    Package["collectd"],
		    File["Prepare www directory"]
		];
    }

    file {
	"Remove README from site":
	    ensure  => absent,
	    force   => true,
	    path    => "$web_root/collection3/README",
	    require => Exec["Install collection site from collectd docs"];
    }

    Package["libconfig-general-perl"]
	-> Package["librrds-perl"]
	-> Package["libregexp-common-perl"]
	-> Package["libhtml-parser-perl"]
	-> Exec["Install collection site from collectd docs"]
	-> Apache::Define::Vhost["collection.$domain"]
}
