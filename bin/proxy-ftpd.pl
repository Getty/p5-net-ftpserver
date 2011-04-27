#!/bin/sh
# -*- perl -*-
exec perl -x -wT $0 "$@";
exit 1;
#!perl

# Net::FTPServer A Perl FTP Server
# Copyright (C) 2000 Bibliotech Ltd., Unit 2-3, 50 Carnwath Road,
# London, SW6 3EG, United Kingdom.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

# Proxy FTP server.
#
# By Richard W.M. Jones <rich@annexia.org>.
#
# $Id: proxy-ftpd.pl,v 1.1 2003/10/17 14:40:37 rwmj Exp $
#
# To run this in background daemon mode, listening on port 2000, do:
#
#   proxy-ftpd -S -p 2000

use strict;
use Net::FTPServer::Proxy::Server;

my $ftps = Net::FTPServer::Proxy::Server->run;
