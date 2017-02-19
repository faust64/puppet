define nagios::define::declare_servicegroup($disp) {
    $ralias = $disp ?  {
	    ""      => iniline_template('<%=name.capitalize-%>'),
	    default => $disp
	}

    nagios_servicegroup {
	$name:
	    alias  => $ralias,
	    notify => Exec["Refresh Icinga configuration"],
	    target => "/etc/nagios/import.d/servicegroup/$name.cfg";
    }
}
