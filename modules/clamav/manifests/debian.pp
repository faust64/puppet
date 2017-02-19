class clamav::debian {
    common::define::package {
	"clamav":
	    notify => Exec["Init ClamAV database"];
    }

    common::define::service {
	"clamav-freshclam":
	    enable => false,
	    ensure => "stopped";
    }

    exec {
	"Init ClamAV database":
	    command     => "freshclam",
	    cwd         => "/",
	    path        => "/usr/bin:/bin",
	    refreshonly => true;
    }

    File["Install Freshclam configuration"]
	-> Exec["Init ClamAV database"]

    Common::Define::Package["clamav"]
	-> Common::Define::Service["clamav-freshclam"]
	-> File["Prepare ClamAV for further configuration"]
}
