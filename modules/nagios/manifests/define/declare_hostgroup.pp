define nagios::define::declare_hostgroup($disp) {
    $ralias = $disp ?  {
	    ""      => iniline_template('<%=name.capitalize-%>'),
	    default => $disp
	}

    nagios_hostgroup {
	$name:
	    alias  => $ralias,
	    notify => Exec["Refresh Icinga configuration"],
	    target => "/etc/nagios/import.d/hostgroups/$name.cfg";
    }
}
