class unionfs::config {
    unionfs::define::mountpoint {
	"agentx":
	    dir   => "/var/agentx";
	"home":
	    dir   => "/home";
	"logs":
	    dir   => "/var/log";
	"postfix":
	    dir   => "/var/lib/postfix",
	    group => lookup("postfix_runtime_group"),
	    owner => lookup("postfix_runtime_user");
	"spool":
	    dir   => "/var/spool";
	"sudo":
	    dir   => "/var/lib/sudo",
	    mode  => "0700";
	"puppet":
	    dir   => lookup("puppet_var_dir"),
	    group => lookup("puppet_runtime_group"),
	    mode  => "0775",
	    owner => lookup("puppet_runtime_user");
    }
}
