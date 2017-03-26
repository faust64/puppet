class opennebula::service {
    if ($opennebula::vars::do_controller) {
	common::define::service {
	    "opennebula":
		require => Common::Define::Package["opennebula"];
	}
    }

    if ($opennebula::vars::do_oneflow) {
	common::define::service {
	    "opennebula-flow":
		require => Common::Define::Package["opennebula-flow"];
	}

	if ($opennebula::vars::do_onegate) {
	    Common::Define::Service["opennebula-flow"]
		-> Common::Define::Service["opennebula-gate"]
	}
	if (defined(Common::Define::Service["opennebula"])) {
	    Common::Define::Service["opennebula"]
		-> Common::Define::Service["opennebula-flow"]
	}
    }

    if ($opennebula::vars::do_onegate) {
	common::define::service {
	    "opennebula-gate":
		require => Common::Define::Package["opennebula-gate"];
	}

	if (defined(Common::Define::Service["opennebula"])) {
	    Common::Define::Service["opennebula"]
		-> Common::Define::Service["opennebula-gate"]
	}
    }

    if ($opennebula::vars::do_sunstone) {
	common::define::service {
	    "opennebula-sunstone":
		require => Common::Define::Package["opennebula-sunstone"];
	}

	if (defined(Common::Define::Service["opennebula"])) {
	    Common::Define::Service["opennebula"]
		-> Common::Define::Service["opennebula-sunstone"]
	}
    }
}
