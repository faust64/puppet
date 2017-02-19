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
	    group => hiera("postfix_runtime_group"),
	    owner => hiera("postfix_runtime_user");
	"spool":
	    dir   => "/var/spool";
	"sudo":
	    dir   => "/var/lib/sudo",
	    mode  => "0700";
	"puppet":
	    dir   => hiera("puppet_var_dir"),
	    group => hiera("puppet_runtime_group"),
	    mode  => "0775",
	    owner => hiera("puppet_runtime_user");
    }
}
