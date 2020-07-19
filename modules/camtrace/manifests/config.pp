class camtrace::config {
    $camtrace_user = $camtrace::vars::runtime_user
    $keyhash       = $camtrace::vars::keyhash
    $keyid         = $camtrace::vars::keyid
    $sudo_conf_dir = $camtrace::vars::sudo_conf_dir

    file {
	"Install Scamd key":
	    content => template("camtrace/key.erb"),
	    group   => $camtrace::vars::runtime_group,
	    mode    => "0644",
	    notify  => Service["scamd"],
	    owner   => $camtrace_user,
	    path    => "/usr/local/etc/scamd.key",
	    require => Class["xorg"];
	"Install camtrace sudoers configuration":
	    content => template("camtrace/sudoers.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0440",
	    owner   => root,
	    path    => "$sudo_conf_dir/sudoers.d/camtrace",
	    require => File["Prepare sudo for further configuration"];
    }
}
