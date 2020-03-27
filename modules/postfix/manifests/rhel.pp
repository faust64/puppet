class postfix::rhel {
    common::define::package {
	"postfix":
    }

    if ($postfix::vars::mail_mx or $postfix::vars::mail_ip) {
	firewalld::define::addrule {
	    "smtp":
		port => 25;
	    "smtps":
		port => 465;
	    "submission":
		port => 587;
	}
    }

    exec {
	"Prepare postfix chroot setup script":
	    command     => "cp -p /usr/share/doc/postfix-*/examples/chroot-setup/LINUX2 /usr/src/postfix-chroot-setup && chmod +x /usr/src/postfix-chroot-setup",
	    creates     => "/usr/src/postfix-chroot-setup",
	    cwd         => "/",
	    notify      => Exec["Setup Postfix chroot"],
	    path        => "/usr/bin:/bin",
	    require     => Common::Define::Package["postfix"];
	"Setup Postfix chroot":
	    command     => "/usr/src/postfix-chroot-setup",
	    cwd         => "/",
	    path        => "/usr/sbin:/sbin:/usr/bin:/bin",
	    refreshonly => true,
	    require     => Common::Define::Service["postfix"];
    }
}
