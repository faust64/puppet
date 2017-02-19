class icinga::contacts {
    if ($icinga::vars::nagios_contacts) {
	each($icinga::vars::nagios_contacts) |$who, $data| {
	    if ($data['alias']) {
		$alias = $data['alias']
	    } else {
		$alias = $who
	    }
	    if ($data['email']) {
		$email = $data['email']
	    } elsif ($icinga::vars::contact_domain != false) {
		$dom = $icinga::vars::contact_domain
		$email = "${who}@$dom"
	    } else {
		$email = $who
	    }
	    if ($data['doslack']) {
		$doslack = $data['doslack']
	    } else {
		$doslack = false
	    }

	    icinga::define::contact {
		$who:
		    aalias  => $alias,
		    contact => $email,
		    doslack => $doslack;
	    }

	    Icinga::Define::Contact[$who]
		-> Icinga::Define::Config["icinga.cfg"]
	}
    }

    if ($icinga::vars::nagios_contact_groups) {
	each($icinga::vars::nagios_contact_groups) |$grp, $data| {
	    if ($data['alias']) {
		$alias = $data['alias']
	    }
	    else {
		$alias = $grp
	    }

	    if ($data['members']) {
		icinga::define::contact_group {
		    $grp:
			aalias  => $alias,
			members => $data['members'];
		}

		Icinga::Define::Contact_group[$grp]
		    -> Icinga::Define::Config["icinga.cfg"]
	    }
	}
    }
}
