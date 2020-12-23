=pod

=head1 NAME

Net::FTPServer::FileHandle - A Net::FTPServer file handle.

=head1 SYNOPSIS

  use Net::FTPServer::FileHandle;

=head1 DESCRIPTION

=head1 METHODS

=over 4

=cut

package Net::FTPServer::FileHandle;

use strict;
use warnings;

use Net::FTPServer::Handle;

use Carp qw(confess);

use vars qw(@ISA);

@ISA = qw(Net::FTPServer::Handle);

# This function is intentionally undocumented. It is only meant to
# be called internally.

sub new
  {
    my $class = shift;
    my $ftps = shift;
    my $path = shift;

    my $self = Net::FTPServer::Handle->new ($ftps);
    $self->{_pathname} = $path;

    return bless $self, $class;
  }

=pod

=item $filename = $fileh->filename;

Return the filename (last) component.

=cut

sub filename
  {
    my $self = shift;

    if ($self->{_pathname} =~ m,([^/]*)$,)
      {
	return $1;
      }

    confess "incorrect pathname: ", $self->{_pathname};
  }

=pod

=item $dirh = $fileh->dir;

Return the directory which contains this file.

=cut

sub dir
  {
    confess "virtual function";
  }

=pod

=item $fh = $fileh->open (["r"|"w"|"a"]);

Open a file handle (derived from C<IO::Handle>, see
L<IO::Handle(3)>) in either read or write mode.

=cut

sub open
  {
    confess "virtual function";
  }

=item $rv = $fileh->delete;

Delete the current file. If the delete command was
successful, then return 0, else if there was an error return -1.

=cut

sub delete
  {
    confess "virtual function";
  }

=item $rv = $fileh->utime($mtime)

Set the mtime of the current file to $mtime (unix timestamp).
If successful return 0.  On error return -1.

=cut

sub utime
  {
    return -1;
  }

1 # So that the require or use succeeds.

__END__

=back

=head1 COPYRIGHT

Copyright (C) 2000 Biblio@Tech Ltd., Unit 2-3, 50 Carnwath Road,
London, SW6 3EG, UK

=head1 SEE ALSO

L<Net::FTPServer(3)>, L<perl(1)>

=head1 SUPPORT

IRC

  Join #perl-help on irc.perl.org. Highlight Getty for fast reaction :).

Repository

  https://github.com/Getty/p5-net-ftpserver
  Pull request and additional contributors are welcome
 
Issue Tracker

  https://github.com/Getty/p5-net-ftpserver/issues

=cut