=pod

=head1 NAME

Net::FTPServer::Full::FileHandle - The full FTP server personality

=head1 SYNOPSIS

  use Net::FTPServer::Full::FileHandle;

=head1 DESCRIPTION

=head1 METHODS

=over 4

=cut

package Net::FTPServer::Full::FileHandle;

use strict;
use warnings;

use Net::FTPServer::FileHandle;

use vars qw(@ISA);

@ISA = qw(Net::FTPServer::FileHandle);

=pod

=item $dirh = $fileh->dir;

Return the directory which contains this file.

=cut

sub dir
  {
    my $self = shift;

    my $dirname = $self->{_pathname};
    $dirname =~ s,[^/]+$,,;

    return Net::FTPServer::Full::DirHandle->new ($self->{ftps}, $dirname);
  }

=pod

=item $fh = $fileh->open (["r"|"w"|"a"]);

Open a file handle (derived from C<IO::Handle>, see
L<IO::Handle(3)>) in either read or write mode.

=cut

sub open
  {
    my $self = shift;
    my $mode = shift;

    return new IO::File $self->{_pathname}, $mode;
  }

=pod

=item ($mode, $perms, $nlink, $user, $group, $size, $time) = $handle->status;

Return the file or directory status. The fields returned are:

  $mode     Mode        'd' = directory,
                        'f' = file,
                        and others as with
                        the find(1) -type option.
  $perms    Permissions Permissions in normal octal numeric format.
  $nlink    Link count
  $user     Username    In printable format.
  $group    Group name  In printable format.
  $size     Size        File size in bytes.
  $time     Time        Time (usually mtime) in Unix time_t format.

In derived classes, some of this status information may well be
synthesized, since virtual filesystems will often not contain
information in a Unix-like format.

=cut

sub status
  {
    my $self = shift;

    my ($dev, $ino, $mode, $nlink, $uid, $gid, $rdev, $size,
	$atime, $mtime, $ctime, $blksize, $blocks)
      = lstat $self->{_pathname};

    # If the file has been removed since we created this
    # handle, then $dev will be undefined. Return dummy status
    # information.
    return ("f", 0000, 1, "-", "-", 0, 0) unless defined $dev;

    # Generate printable user/group.
    my $user = getpwuid ($uid) || "-";
    my $group = getgrgid ($gid) || "-";

    # Permissions from mode.
    my $perms = $mode & 0777;

    # Work out the mode using special "_" operator which causes Perl
    # to use the result of the previous stat call.
    $mode
      = (-f _ ? 'f' :
	 (-d _ ? 'd' :
	  (-l _ ? 'l' :
	   (-p _ ? 'p' :
	    (-S _ ? 's' :
	     (-b _ ? 'b' :
	      (-c _ ? 'c' : '?')))))));

    return ($mode, $perms, $nlink, $user, $group, $size, $mtime);
  }

=pod

=item $rv = $handle->move ($dirh, $filename);

Move the current file (or directory) into directory C<$dirh> and
call it C<$filename>. If the operation is successful, return 0,
else return -1.

Underlying filesystems may impose limitations on moves: for example,
it may not be possible to move a directory; it may not be possible
to move a file to another directory; it may not be possible to
move a file across filesystems.

=cut

sub move
  {
    my $self = shift;
    my $dirh = shift;
    my $filename = shift;

    die if $filename =~ /\//;	# Should never happen.

    my $new_name = $dirh->{_pathname} . $filename;

    rename $self->{_pathname}, $new_name or return -1;

    $self->{_pathname} = $new_name;
    return 0;
  }

=pod

=item $rv = $fileh->delete;

Delete the current file. If the delete command was
successful, then return 0, else if there was an error return -1.

=cut

sub delete
  {
    my $self = shift;

    unlink $self->{_pathname} or return -1;

    return 0;
  }

=item $link = $fileh->readlink;

If the current file is really a symbolic link, read the contents
of the link and return it.

=cut

sub readlink
  {
    my $self = shift;

    return readlink $self->{_pathname};
  }

=item $rv = $fileh->utime($mtime)

Set the mtime of the current file to $mtime (unix timestamp).
If successful, then return 0, else is the was an error return -1.

=cut

sub utime
  {
    my $self = shift;
    my $mtime = shift;
    utime($mtime, $mtime, $self->{_pathname}) || return -1;
    return 0;
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