class shell::bash {
    $charset   = $shell::vars::charset
    $locale    = $shell::vars::locale
    $puppetvar = $shell::vars::puppet_var_dir
    $prompt    = $shell::vars::prompt

    file {
	"Main Bash configuration":
	    content => template("shell/bash.bashrc.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "/etc/bash.bashrc";
	"Bash root configuration":
	    group   => hiera("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "/root/.bashrc",
	    source  => "puppet:///modules/shell/user.bashrc";
	"Bash skel configuration":
	    group   => hiera("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "/etc/skel/.bashrc",
	    source  => "puppet:///modules/shell/user.bashrc";
    }
}
