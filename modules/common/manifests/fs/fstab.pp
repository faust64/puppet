class common::fs::fstab {
    $mountpoints = hiera("fstab_mountpoint")

    create_resources(common::define::mountpoint, $mountpoints)
}
