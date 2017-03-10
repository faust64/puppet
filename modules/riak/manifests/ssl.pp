class riak::ssl {
# Note: so far, trying to use an actual PKI generating server certificates, or
# using certificates bigger than 2K were suspected causes of that whole thing
# not working. Basho support pointed us to an internal doc explaining how
# to generate self-signed client certificates for the server side, no
# documentation in regards to the client-side certificates generation (and
# so far, despide Basho support help, we were not able to properly connect
# using client-certificate authentication, ... and we're also still waiting
# for some haproxy configuration sample properly dealing with health checks, ...
# TLDR: do not enable riak_ssl, unless you're up for some troubleshooting, ...
# Additional note: the following looks very much like what Basho told us to do
# https://gist.github.com/pogzie/971373113c3606d8b3bf
    file {
	"Prepare Riak SSL configuration directory":
	    ensure  => directory,
	    group   => $riak::vars::runtime_group,
	    mode    => "0751",
	    owner   => root,
	    path    => "/etc/riak/ssl",
	    require => File["Prepare riak for further configuration"];
    }

    pki::define::wrap {
	"riak":
	    ca      => "riak",
	    group   => $riak::vars::runtime_group,
	    mode    => "0640",
	    owner   => root,
	    reqfile => "Prepare Riak SSL configuration directory",
	    within  => "/etc/riak/ssl";
    }
}
