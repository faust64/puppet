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
	"auto7-64b":
	    autopart => true,
	    rhelvers => 7,
	    server   => true;
	"manual7-64b":
	    rhelvers => 7,
	    server   => true;
	"desktop7-auto-64b":
	    autopart => true,
	    rhelvers => 7;
	"desktop7-manual-64b":
	    rhelvers => 7;
	"auto-64b":
	    autopart => true,
	    server   => true;
	"manual-64b":
	    server   => true;
	"desktop-auto-64b":
	    autopart => true;
	"desktop-manual-64b":
    }

    tftpd::define::ks_redhat {
	"auto6-64b":
	    autopart => true,
	    rhelvers => 6.9,
	    server   => true;
	"manual6-64b":
	    rhelvers => 6.9,
	    server   => true;
	"desktop-auto6-64b":
	    autopart => true,
	    rhelvers => 6.9;
	"desktop-manual6-64b":
	    rhelvers => 6.9;
	"auto7-64b":
	    autopart => true,
	    rhelvers => 7.8,
	    server   => true;
	"manual7-64b":
	    rhelvers => 7.8,
	    server   => true;
	"desktop7-auto-64b":
	    autopart => true,
	    rhelvers => 7.8;
	"desktop7-manual-64b":
	    rhelvers => 7.8;
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
