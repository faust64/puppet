define network::define::bpf() {
    exec {
	"Create BPF device #$name":
	    command => "mknod bpf$name c 0 0",
	    cwd     => "/dev",
	    path    => "/sbin:/bin",
	    unless  => "test -c bpf$name";
    }
}
