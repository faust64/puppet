class tinytinyrss {
    include tinytinyrss::vars
    include common::tools::unzip
    include openldap::client
    include tinytinyrss::install
    include tinytinyrss::jobs
    include tinytinyrss::scripts
    include tinytinyrss::webapp
}
