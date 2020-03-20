class common::physical::linuxcounter {
    cron {
	"Update LinuxCounter data":
	    command => "/usr/local/bin/lico-update -m >/dev/null 2>&1",
	    ensure  => absent;
    }

    file {
	"Prepare LinuxConter for further configuration":
	    ensure  => absent,
	    force   => yes,
	    path    => "/root/.linuxcounter";
	"Install linux-counter update script":
	    ensure  => absent,
	    path   => "/usr/local/bin/lico-update";
    }
}
