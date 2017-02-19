class sendmail::freebsd {
    common::define::lined {
	"Enable sendmail":
	    line  => 'sendmail_enable=YES',
	    match => '^sendmail_enable=',
	    path  => '/etc/rc.conf';
	"Enable sendmail outbound":
	    line  => 'sendmail_outbound_enable=YES',
	    match => '^sendmail_outbound_enable=',
	    path  => '/etc/rc.conf';
	"Enable sendmail msp queue":
	    line  => 'sendmail_msp_queue_enable=YES',
	    match => '^sendmail_msp_queue_enable=',
	    path  => '/etc/rc.conf';
    }

    Common::Define::Lined["Enable sendmail msp queue"]
	-> Common::Define::Lined["Enable sendmail outbound"]
	-> Common::Define::Lined["Enable sendmail"]
	-> Service["sendmail"]
}
