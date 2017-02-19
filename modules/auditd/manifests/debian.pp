class auditd::debian {
    common::define::package {
	"auditd":
    }

    Package["auditd"]
	-> File["Prepare auditd for further configuration"]
}
