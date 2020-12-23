=pod

=head1 NAME

Net::FTPServer::DirHandle - A Net::FTPServer directory handle.

=head1 SYNOPSIS

  use Net::FTPServer::DirHandle;

=head1 DESCRIPTION

=head1 METHODS

=over 4

=cut

package Net::FTPServer::DirHandle;

use strict;
use warnings;

use Carp qw(confess);

use Net::FTPServer::Handle;

use vars qw(@ISA);

@ISA = qw(Net::FTPServer::Handle);

=pod

=item $dirh = new Net::FTPServer::DirHandle ($ftps);

Create a new directory handle. The directory handle corresponds to "/".

=cut

sub new
  {
    my $class = shift;
    my $ftps = shift;

    # Only internal calls will supply the $path argument. It must end
    # with a "/".
    my $path = shift || "/";

    my $self = Net::FTPServer::Handle->new ($ftps);
    $self->{_pathname} = $path;

    return bless $self, $class;
  }

=pod

=item $dirh = $dirh->parent;

Return the parent directory of the directory C<$dirh>. If
the directory is already "/", this returns the same directory handle.

=cut

sub parent
  {
    my $self = shift;

    # Already in "/" ?
    return $self if $self->is_root;

    my $new_pathname = $self->{_pathname};
    $new_pathname =~ s,[^/]*/$,,;

    return Net::FTPServer::DirHandle->new ($self->{ftps}, $new_pathname);
  }

=pod

=item $rv = $dirh->is_root;

Return true if the current directory is the root directory.

=cut

sub is_root
  {
    my $self = shift;

    return $self->{_pathname} eq "/";
  }

=pod

=item $handle = $dirh->get ($filename);

Return the file or directory C<$handle> corresponding to
the file C<$filename> in directory C<$dirh>. If there is
no file or subdirectory of that name, then this returns
undef.

=cut

sub get
  {
    confess "virtual function";
  }

=pod

=item $ref = $dirh->list ([$wildcard]);

Return a list of the contents of directory C<$dirh>. The list
returned is a reference to an array of pairs:

  [ $filename, $handle ]

The list returned does I<not> include "." or "..".

The list is sorted into alphabetical order automatically.

=cut

sub list
  {
    confess "virtual function";
  }


=pod

=item $ref = $dirh->_list_status ([$wildcard]);

Just a dumb wrapper function.  Returns the same thing as
list_status(), but also includes the special directories
"." and ".." if no wildcard is specified.

=cut

sub _list_status
  {
    my $self = shift;
    my $wildcard = shift;
    my @array = ();
    unless ($wildcard)
      {
	# I suppose that there will be some FTP clients out there which
	# will get confused if they don't see . and .. entries.
	push (@array, [ ".",  $self ]);
	push (@array, [ "..", $self->parent ]);
      }
    push (@array, @{ $self->list_status ($wildcard) });
    return \@array;
  }

=pod

=item $ref = $dirh->list_status ([$wildcard]);

Return a list of the contents of directory C<$dirh> and
status information. The list returned is a reference to
an array of triplets:

  [ $filename, $handle, $statusref ]

where $statusref is the tuple returned from the C<status>
method (see L<Net::FTPServer::Handle>).

The list returned does I<not> include "." or "..".

The list is sorted into alphabetical order automatically.

=cut

sub list_status
  {
    confess "virtual function";
  }

=item $rv = $dirh->delete;

Delete the current directory. If the delete command was
successful, then return 0, else if there was an error return -1.

It is normally only possible to delete a directory if it
is empty.

=cut

sub delete
  {
    confess "virtual function";
  }

=item $rv = $dirh->mkdir ($name);

Create a subdirectory called C<$name> within the current directory
C<$dirh>.

=cut

sub mkdir
  {
    confess "virtual function";
  }

=item $file = $dirh->open ($filename, "r"|"w"|"a");

Open or create a file called C<$filename> in the current directory,
opening it for either read, write or append. This function
returns a C<IO::File> handle object.

=cut

sub open
  {
    confess "virtual function";
  }

=item $rv = $dirh->utime($mtime)

Set the mtime of the directory to the unix timestamp mtime.

Returns 0 on success or -1 on error.

=cut

sub utime
  {
    return -1; # not supported
  }

=cut

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