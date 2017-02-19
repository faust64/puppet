class common::define::schedules {
    schedule {
	"FromTimeToTime":
	    period  => monthly,
	    range   => "12 - 13";
	"AsTimeGoesBy":
	    period  => weekly,
	    range   => "6 - 7";
	"TimeHasComeToday":
	    period  => daily,
	    range   => "0:00 - 8:00";
	"TimeAfterTime":
	    period  => hourly;
    }
}
