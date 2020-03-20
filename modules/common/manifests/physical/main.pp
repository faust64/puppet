class common::physical::main {
    include common::physical::fs
    include common::physical::fingerprints
##FIXME / DROPME##
    include common::physical::linuxcounter
##//##
    include common::physical::netpackages
    include common::physical::perf
    include common::physical::reboot
    include common::physical::syspackages
    include common::physical::triggerhappy
    include common::physical::u2f
    include mysysctl::define::nopowerdown
    include mrtg::register

    if (lookup("with_collectd") == true) {
	include collectd
    }
    if (lookup("with_munin") == true) {
	include common::physical::munin
    }
    if (lookup("with_nagios") == true) {
	include common::physical::nagios
    }

    if ($operatingsystem == "FreeBSD") {
	include bsnmpd
    } else {
	include snmpd
    }

    if ($kernel == "Linux" and lookup("nagios_md_raid") == false) {
	class {
	    common::free:
		stage => "antilope";
	}
    }
}
