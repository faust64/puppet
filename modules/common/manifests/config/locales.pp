#class common::config::locales {
#    $charset = lookup("locale_charset")
#    $locale  = lookup("locale_LOCALE")
#
#    exec {
#	"Generate required locales":
#	    command => "localedef -i $locale -f $charset $locale.$charset",
#	    path    => "/usr/bin:/bin";
#    }
#}
