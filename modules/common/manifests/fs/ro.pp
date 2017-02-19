class common::fs::ro($options = "remount",
		     $what    = "/") {
    $point = regsubst($what, '/', '\\/', 'G')

    exec {
	"Remount $what as read-only":
	    command => "mount $what -o $options,ro",
	    cwd     => '/etc',
	    onlyif  =>
		[
		    "awk '/[ 	]$point[ 	]/{print \",\"\$4\",\"}' fstab | grep '[^a-z]ro[^a-z]'",
		    "mount | awk '/ $point /{print \",\"\$6\",\"}' | grep -v '[^a-z]ro[^a-z]'",
		],
	    path    => '/usr/bin:/bin';
    }
}
