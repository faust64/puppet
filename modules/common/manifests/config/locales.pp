#class common::config::locales {
#    $charset = hiera("locale_charset")
#    $locale  = hiera("locale_LOCALE")
#
#    exec {
#	"Generate required locales":
#	    command => "localedef -i $locale -f $charset $locale.$charset",
#	    path    => "/usr/bin:/bin";
#    }
#}
