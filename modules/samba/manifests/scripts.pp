class samba::scripts {
    $contact = $samba::vars::contact
    $dir_map = $samba::vars::dir_map

    file {
	"Install samba panic action script":
	    content => template("samba/scripts/panic.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "/usr/local/bin/samba_panic";
	"Install set_perms utility":
	    content => template("samba/scripts/perms.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "/usr/local/bin/set_perms";
	"Install purge goinfre utility":
	    content => template("samba/scripts/goinfre.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0750",
	    owner   => root,
	    path    => "/usr/local/bin/purge_goinfre";
	"Install purge junks utility":
	    content => template("samba/scripts/junks.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0750",
	    owner   => root,
	    path    => "/usr/local/bin/purge_junks";
    }
}
