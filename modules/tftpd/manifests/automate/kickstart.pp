class tftpd::automate::kickstart {
    tftpd::define::ks_centos {
	"auto6-32b":
	    autopart => true,
	    rhelarch => "i386",
	    rhelvers => 6,
	    server   => true;
	"auto6-64b":
	    autopart => true,
	    rhelvers => 6,
	    server   => true;
	"manual6-32b":
	    rhelarch => "i386",
	    rhelvers => 6,
	    server   => true;
	"manual6-64b":
	    rhelvers => 6,
	    server   => true;
	"desktop-auto6-32b":
	    autopart => true,
	    rhelarch => "i386",
	    rhelvers => 6;
	"desktop-auto6-64b":
	    autopart => true,
	    rhelvers => 6;
	"desktop-manual6-32b":
	    rhelarch => "i386",
	    rhelvers => 6;
	"desktop-manual6-64b":
	    rhelvers => 6;
	"auto-64b":
	    autopart => true,
	    server   => true;
	"manual-64b":
	    server   => true;
	"desktop-auto-64b":
	    autopart => true;
	"desktop-manual-64b":
    }
}
