class iscsiinitiator::rhel {
    common::define::package {
	"iscsi-initiator-utils":
    }

    Package["iscsi-initiator-utils"]
	-> File["Prepare iSCSI for further configuration"]
}
