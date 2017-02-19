class vebackup::vars {
    $contact             = hiera("backup_contact")
    $backup_hour         = hiera("backup_hour")
    $backup_min          = hiera("backup_min")
    $jumeau              = hiera("jumeau")
    $remote_kvm_vg       = hiera("backup_kvm_vg")
    $triplet             = hiera("triplet")
}
