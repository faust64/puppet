class muninnode::plugins {
    file {
	"Install Munin custom plugins":
	    group   => lookup("gid_zero"),
	    ignore  => [ ".svn", ".git" ],
	    mode    => "0755",
	    owner   => root,
	    path    => $muninnode::vars::munin_plugins_dir,
	    recurse => true,
	    source  => "puppet:///modules/muninnode/custom_plugins";
    }
}
