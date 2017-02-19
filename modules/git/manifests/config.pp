class git::config {
    $author_name  = $git::vars::author_name
    $author_email = $git::vars::author_email

    file {
	"Install root .gitconfig":
	    content => template("git/config.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "/root/.gitconfig";
    }
}
