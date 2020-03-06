class qemu::config {
    if ($fqdn == "nemesis.adm.intra.unetresgrossebite.com" or $fqdn == "thanatos.adm.intra.unetresgrossebite.com") {
    common::define::insertmodule { "virtio_balloon": }
    }
}
