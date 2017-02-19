class yum {
    include yum::config
    include yum::filetraq
    include yum::local
}
