class rkhunter::debian {
    common::define::package {
	"rkhunter":
	    notify => Exec["Update rkhunter"];
    }

    Package["rkhunter"]
	-> File["Install rkhunter main configuration"]
}
