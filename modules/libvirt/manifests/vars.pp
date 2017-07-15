class libvirt::vars {
    $runtime_group = lookup("libvirt_runtime_group")
    $runtime_user  = lookup("libvirt_runtime_user")
}
