class auditd::plugins {
    auditd::define::plugin {
	"af_unix":
	    args => "0640 /var/run/audispd_events";
	"syslog":
    }
}
