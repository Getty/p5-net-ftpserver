=pod

=head1 NAME

Net::FTPServer::InMem::Server - Store files in local memory

=head1 SYNOPSIS

  inmem-ftpd [-d] [-v] [-p port] [-s] [-S] [-V] [-C conf_file]

=head1 DESCRIPTION

C<Net::FTPServer::InMem::Server> is the example FTP server
personality. This personality implements a simple
FTP server which stores files in local memory. This personality
is used mainly for automatic testing in the test suites (see the
C<t/> directory in the distribution).

=head1 METHODS

=over 4

=cut

package Net::FTPServer::InMem::Server;

use strict;
use warnings;

use Net::FTPServer;
use Net::FTPServer::InMem::FileHandle;
use Net::FTPServer::InMem::DirHandle;

use vars qw($VERSION @ISA);
( $VERSION ) = $Net::FTPServer::VERSION || "2.000dev";

@ISA = qw(Net::FTPServer);

# Variables.
use vars qw(%users);

$users{rich} = '123456';
$users{rob} = '123456';

# This is called before configuration.

sub pre_configuration_hook
  {
    my $self = shift;

    $self->{version_string} .= " Net::FTPServer::InMem/$VERSION";
  }

# Perform login against the database.

sub authentication_hook
  {
    my $self = shift;
    my $user = shift;
    my $pass = shift;
    my $user_is_anon = shift;

    # Allow anonymous access.
    return 0 if $user_is_anon;

    # Verify access against our short list of username/password combinations.
    return 0 if exists $users{$user} && $users{$user} eq $pass;

    # Unsuccessful login.
    return -1;
  }

# Called just after user C<$user> has successfully logged in.

sub user_login_hook
  {
    # Override the default by doing nothing.
  }

#  Return an instance of Net::FTPServer::InMem::DirHandle
# corresponding to the root directory.

sub root_directory_hook
  {
    my $self = shift;

    return new Net::FTPServer::InMem::DirHandle ($self);
  }

1 # So that the require or use succeeds.

__END__

=back 4

=head1 FILES

  /etc/ftpd.conf
  /usr/lib/perl5/site_perl/5.005/Net/FTPServer.pm
  /usr/lib/perl5/site_perl/5.005/Net/FTPServer/DirHandle.pm
  /usr/lib/perl5/site_perl/5.005/Net/FTPServer/FileHandle.pm
  /usr/lib/perl5/site_perl/5.005/Net/FTPServer/Handle.pm
  /usr/lib/perl5/site_perl/5.005/Net/FTPServer/InMem/Server.pm
  /usr/lib/perl5/site_perl/5.005/Net/FTPServer/InMem/DirHandle.pm
  /usr/lib/perl5/site_perl/5.005/Net/FTPServer/InMem/FileHandle.pm

=head1 AUTHORS

Richard Jones (rich@annexia.org).

=head1 COPYRIGHT

Copyright (C) 2000 Biblio@Tech Ltd., Unit 2-3, 50 Carnwath Road,
London, SW6 3EG, UK

=head1 SEE ALSO

L<Net::FTPServer(3)>.

=cut
