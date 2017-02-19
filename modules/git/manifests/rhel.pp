class git::rhel {
    common::define::package {
	"git":
    }

    if ($git::vars::with_gitlist == true
	or $git::vars::with_gitlab == true) {
	notify{ "unimplemented gitlist/gitlab on rhel": }
    }
}
