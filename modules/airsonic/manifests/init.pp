class airsonic {
    include airsonic::vars

    if ($airsonic::vars::do_flac == true) {
	include common::tools::flac
    }
    include common::tools::ffmpeg
    include common::tools::lame

    include airsonic::install
    include airsonic::config
    include airsonic::nagios
    include airsonic::rsyslog
    include airsonic::scripts
    include airsonic::service
    include airsonic::webapp

    if ($airsonic::vars::sync_directories == false) {
	include airsonic::register
    } else {
	include airsonic::collect
	include airsonic::jobs
	include airsonic::masterscripts
    }
}
