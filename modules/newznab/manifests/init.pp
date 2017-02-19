class newznab {
    include common::tools::ffmpeg
    include common::tools::lame
    include newznab::vars
    include newznab::config
    include newznab::install
    include newznab::jobs
    include newznab::scripts
    include newznab::webapp
}
