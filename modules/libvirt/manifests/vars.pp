class libvirt::vars {
    $runtime_group      = hiera("libvirt_runtime_group")
    $runtime_user       = hiera("libvirt_runtime_user")
}
