#!/usr/bin/env perl
# PODNAME: Net::FTPServer Script

use strict;
use warnings;
use Net::FTPServer::Full::Server;

my $ftps = Net::FTPServer::Full::Server->run;
