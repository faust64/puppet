class mrtg::scripts {
    file {
	"Install mrtg update script":
	    group   => hiera("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "/usr/local/bin/mrtgupdate",
	    source  => "puppet:///modules/mrtg/scripts/update";
	"Install mrtg switches registration script":
	    group   => hiera("gid_zero"),
	    mode    => "0755",
	    notify  => Exec["Register local switches"],
	    owner   => root,
	    path    => "/usr/local/bin/mrtg_register_sw",
	    source  => "puppet:///modules/mrtg/scripts/register_sw";
	"Install mrtg archive script":
	    content => template("mrtg/mrtgarchive.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "/usr/local/bin/mrtgarchive";
	"Install wmap archive script":
	    content => template("mrtg/wmaparchive.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "/usr/local/bin/wmaparchive";
    }
}
