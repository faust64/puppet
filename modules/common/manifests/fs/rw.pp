class common::fs::rw($options = "remount",
		     $what    = "/") {
    $point = regsubst($what, '/', '\\/', 'G')

    exec {
	"Remount $what as read-write":
	    command => "mount $what -o $options,rw",
	    cwd     => '/',
	    path    => '/usr/bin:/bin',
	    unless  => "mount | awk '/ $point /{print \",\"\$6\",\"}' | grep -v '[^a-z]ro[^a-z]'";
    }
}
