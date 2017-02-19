class openvz::scripts {
    $contact  = $openvz::vars::contact
    $nas_host = $openvz::vars::nas_host
    $nas_root = $openvz::vars::nas_root

    file {
	"Install OpenVZ custom scripts":
	    group   => hiera("gid_zero"),
	    ignore  => [ ".svn", ".git" ],
	    owner   => root,
	    path    => "/usr/local/bin",
	    recurse => true,
	    source  => "puppet:///modules/openvz/bin";
	"Install OpenVZ archive script":
	    content => template("openvz/backup_vz_nas.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0750",
	    owner   => root,
	    path    => "/usr/local/bin/backup_vz_nas";
    }
}
