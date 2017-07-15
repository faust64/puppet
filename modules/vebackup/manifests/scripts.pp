class vebackup::scripts {
    $contact       = $vebackup::vars::contact
    $do_kvm        = $vebackup::do_kvm
    $do_openvz     = $vebackup::do_openvz
    $do_xen        = $vebackup::do_xen
    $jumeau        = $vebackup::vars::jumeau
    $remote_kvm_vg = $vebackup::vars::remote_kvm_vg

    file {
	"Install Backup-VMs script":
	    content => template("vebackup/backup.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0750",
	    owner   => root,
	    path    => "/usr/local/bin/backup_ve_1by1.sh";
	"Install Xen (dd)backup script":
	    group   => lookup("gid_zero"),
	    mode    => "0750",
	    owner   => root,
	    path    => "/usr/local/sbin/XENbackup",
	    source  => "puppet:///modules/vebackup/XEN";
	"Install Xen (tar)backup script":
	    group   => lookup("gid_zero"),
	    mode    => "0750",
	    owner   => root,
	    path    => "/usr/local/sbin/XENbackupfs",
	    source  => "puppet:///modules/vebackup/XENfs";
	"Install mychroot script":
	    group   => lookup("gid_zero"),
	    mode    => "0750",
	    owner   => root,
	    path    => "/usr/local/sbin/mychroot",
	    source  => "puppet:///modules/vebackup/mychroot";
    }
}
