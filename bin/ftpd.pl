#!/usr/bin/env perl

use strict;
use warnings;
use Net::FTPServer::Full::Server;

my $ftps = Net::FTPServer::Full::Server->run;
