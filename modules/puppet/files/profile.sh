#!/bin/sh

if ! echo $PATH | grep -q /opt/puppetlabs/bin ; then
    export PATH=$PATH:/opt/puppetlabs/bin
fi
