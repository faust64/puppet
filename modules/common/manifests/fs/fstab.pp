class common::fs::fstab {
    $mountpoints = lookup("fstab_mountpoint")

    create_resources(common::define::mountpoint, $mountpoints)
}
