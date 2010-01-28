#  Copyright (c) 2010 by Henrik P.  All rights reserved.
package Win32::Symboliclink;

use 5.010001;
use strict;
use warnings;
use Carp qw(croak);

require Exporter;

our @ISA = qw(Exporter);

our %EXPORT_TAGS = ( 'all' => [ qw(
	
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw( CreateSymLink CreateSymbolicLink 
                  RemoveSymLink RemoveDirectory 
                  DeleteFile FILE FOLDER GetVersion GetSyLinkError );

our $VERSION = '0.01';

require XSLoader;
XSLoader::load('Win32::Symboliclink', $VERSION);

# Preloaded methods go here.

use constant FILE      => 0x0;
use constant FOLDER    => 0x1;

croak "error [Win32::Symboliclink] : Supported OS is Windows NT >= 6" unless ( GetVersion() gt "5" ) ;

# CreateSymbolicLink
sub CreateSymLink
{
    #Die if less or more than one parameter was passed
    croak "error [CreateJunction] : usage CreateJunction(SymlinkFileName,TargetFileName)" if @_ != 2 ;
    my $lpSymlinkFileName = shift;  #Symbolic link to be created
    my $lpTargetFileName  = shift;  #File or Folder target 
    #Check if parameter is a folder
    if ( -d $lpTargetFileName )
    {
        return ( CreateSymbolicLink ( $lpSymlinkFileName,$lpTargetFileName,FOLDER ) ) ;
    } #if
    #Check if parameter is a file
    elsif ( -f $lpTargetFileName )
    {
        return ( CreateSymbolicLink ( $lpSymlinkFileName,$lpTargetFileName,FILE ) ) ;
    } #else
    #Parameter is no file and no folder
    else
    {
        #returns ERROR_INVALID_HANDLE 
        return 2 ;
    } #else

} #sub RemoveSymbolicLink 






# RemoveSymbolicLink
sub RemoveSymLink
{

    #Die if less or more than one parameter was passed
    croak "error [RemoveJunction] : usage RemoveJunction(SymlinkFileName)" if @_ != 1 ;
    my $lpSymlinkFileName = shift;
    #Check if parameter is a folde
    if ( -d $lpSymlinkFileName )
    {
        return ( RemoveDirectory ( $lpSymlinkFileName ) ) ;
    } #if
    #Check if parameter is a file
    elsif ( -f $lpSymlinkFileName )
    {
        return ( DeleteFile ( $lpSymlinkFileName ) ) ;
    } #else
    #Parameter is no file and no folder
    else
    {
        #returns ERROR_INVALID_HANDLE
        return 2 ;
    } #else

} #sub RemoveSymbolicLink 


1;
__END__


=head1 NAME

Win32::Symboliclink - Perl extension to create a symbolic link.

=head1 SYNOPSIS

  use Win32::Symboliclink;;

  #Create SymbolicLink
  my $lastCreateErrorRet = CreateSymLink("C:\\SYSWOW64","C:\\Windows\\System32");
  print "Returncode: $lastCreateErrorRet \n" ;
  my $lastCreateErroMsg = GetSyLinkError() ;
  print "Message: $lastCreateErroMsg\n" ;

  #Remove SymbolicLink
  my $lastRemoveErrorRet = RemoveSymLink("C:\\SYSWOW64") ;
  print "Returncode: $lastRemoveErrorRet \n" ;
  my $lastRemoveErrorMsg = GetSyLinkError() ;
  print "Message: $lastRemoveErrorMsg\n" ;

=head1 DESCRIPTION

With this module you can create a symbolic link <SYMLINKD> (not <JUNCTION>) under Windows Vista and higher. This module requires Windows Vista or higher.  

=head2 Win32::Symboliclink Functions

=head3 CreateSymLink ( Link, Destination )

B<Link>
The symbolic link to be created.

B<Destination> is the name of the target for the symbolic link to be created.
It can either be a file or a folder.

Create a symbolic link. If the function succeeds, the return value is zero. If the function fails, the return value is nonzero (GetLastError). To get extended error information call GetSyLinkError(). 
           
=head3 RemoveSymLink ( Link )

B<Link>
The symbolic link to be deleted.

Remove a symbolic link. Alternativ you can use unlink or rmdir. If the function succeeds, the return value is zero. If the function fails, the return value is nonzero (GetLastError). To get extended error information call GetSyLinkError(). Deleting a symbolic link does not affect the source file.

B<NOTE: > A link can also be removed with rmdir or unlink.

=head3 GetSyLinkError ( )

This function returns the last error message (string). The last error code is return by the functions thereselves.


=head1 SEE ALSO

Alternative you can use Win32::API of course.

Win32::API - http://search.cpan.org/~cosimo/Win32-API-0.59/API.pm


C<my $lpSymlinkFileName = "C:\\Windows\\SysWOW32";>

C<my $lpTargetFileName  = "C:\\Windows\\System32";>

C<my $dwFlags           = "";>
     
my $CreateSymbolicLink = new Win32::API('kernel32', "CreateSymbolicLink",['P','P','N'],'I');
   $CreateSymbolicLink->Call($lpSymlinkFileName,$lpTargetFileName,$dwFlags)                 
   or die "Could not create Symboliclink: $^E"                                              

B<NOTE: > A link can be removed with rmdir or unlink.

C<Win32::SymLink>
C<Win32::Hardlink>

=head1 AUTHOR

Henrik  P., E<lt>hendriks@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2010 by Henrik P.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.10.1 or,
at your option, any later version of Perl 5 you may have available.


=cut
