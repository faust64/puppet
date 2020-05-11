class katello::hammer {
    $admpw       = $katello::vars::admin_password
    $admusr      = $katello::vars::admin_user
    $foreman_url = $katello::vars::foreman_url

    common::define::package {
	"tfm-rubygem-hammer_cli":
	    require => Yum::Define::Repo["foreman"];
    }

    file {
	"Prepare hammer configuration root":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0700",
	    owner   => "root",
	    path    => "/root/.hammer";
	"Prepare hammer modules root":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0700",
	    owner   => "root",
	    path    => "/root/.hammer/cli.modules.d",
	    require => File["Prepare hammer configuration root"];
	"Install hammer cli configuration":
	    content => template("katello/hammer.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0600",
	    owner   => "root",
	    path    => "/root/.hammer/cli.modules.d/foreman.yml",
	    require => File["Prepare hammer modules root"];
    }

    if (defined(Exec["Initializes Katello"])) {
	Exec["Initializes Katello"]
	    -> File["Install hammer cli configuration"]
    }
}
