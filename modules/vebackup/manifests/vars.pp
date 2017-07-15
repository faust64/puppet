class vebackup::vars {
    $contact       = lookup("backup_contact")
    $backup_hour   = lookup("backup_hour")
    $backup_min    = lookup("backup_min")
    $jumeau        = lookup("jumeau")
    $remote_kvm_vg = lookup("backup_kvm_vg")
    $triplet       = lookup("triplet")
}
