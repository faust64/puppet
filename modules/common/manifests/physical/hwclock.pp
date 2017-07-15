class common::physical::hwclock {
    file {
	"Install fake-hwclock crontab":
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "/etc/cron.daily/fake-hwclock",
	    source  => "puppet:///modules/common/fake-hwclock-cron";
    }

    if (lookup("with_munin") == true) {
	if ($kernel == "Linux") {
	    muninnode::define::probe {
		[
		    "ntp_kernel_err",
		    "ntp_kernel_pll_freq",
		    "ntp_kernel_pll_off"
		]:
	    }
	}
    }
}
