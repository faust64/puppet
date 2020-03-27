class katello::nagios {
    include apache::nagios

    Exec["Reload Katello Services"]
	-> Class["apache::nagios"]
}
