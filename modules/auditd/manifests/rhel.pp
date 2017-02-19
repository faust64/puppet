class auditd::rhel {
    common::define::package {
	"auditd":
    }

    Package["auditd"]
	-> File["Prepare auditd for further configuration"]
}
