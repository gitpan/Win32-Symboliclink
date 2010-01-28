#include "EXTERN.h"
#include "windows.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"

#define BUFSIZE	1024

MODULE = Win32::Symboliclink		PACKAGE = Win32::Symboliclink		

  
#############################################################
#
# DWORD WINAPI GetLastError(void);
#
# http://msdn.microsoft.com/en-us/library/ms679360%28VS.85%29.aspx
#
# DWORD WINAPI FormatMessage(
#   __in      DWORD dwFlags,
#   __in_opt  LPCVOID lpSource,
#   __in      DWORD dwMessageId,
#   __in      DWORD dwLanguageId,
#   __out     LPTSTR lpBuffer,
#   __in      DWORD nSize,
#   __in_opt  va_list *Arguments
# );
#
# http://msdn.microsoft.com/en-us/library/ms679351%28VS.85%29.aspx
#
#############################################################
  
    
char *
GetSyLinkError()
CODE:
  char msgbuf[BUFSIZE];
  DWORD SymLinkLastError = NULL ;
  
  SymLinkLastError  = GetLastError();
  FormatMessageA(FORMAT_MESSAGE_FROM_SYSTEM, 0, SymLinkLastError, 0, msgbuf, sizeof(msgbuf)-1, NULL) ;
  RETVAL = msgbuf ;
OUTPUT:
  RETVAL      
     
     
#############################################################
#
# DWORD WINAPI GetVersion(void);
#
# http://msdn.microsoft.com/en-us/library/ms724439%28VS.85%29.aspx
#
#############################################################
           

DWORD
GetVersion()
CODE:
  
  DWORD dwVersion = 0; 
  dwVersion = GetVersion();
 
  RETVAL = (DWORD)(LOBYTE(LOWORD(dwVersion))); 
OUTPUT:
  RETVAL
    
#############################################################
#
# BOOLEAN WINAPI CreateSymbolicLink(
#   __in  LPTSTR lpSymlinkFileName,
#   __in  LPTSTR lpTargetFileName,
#   __in  DWORD dwFlags
# );
# 
# http://msdn.microsoft.com/en-us/library/aa363866%28VS.85%29.aspx
#
#############################################################            
           
           
BOOL
CreateSymbolicLink( lpSymlinkFileName, lpTargetFileName, dwFlags )
    char *  lpSymlinkFileName 
    char *  lpTargetFileName
    DWORD   dwFlags  
CODE:
    if (!CreateSymbolicLink(lpSymlinkFileName, lpTargetFileName, dwFlags))
    {
        RETVAL = GetLastError() ;
    }
    else
    {
        SetLastError(0) ;
        RETVAL = 0 ;    
    }
OUTPUT:
  RETVAL



#############################################################
#
# BOOL WINAPI RemoveDirectory(
#   __in  LPCTSTR lpPathName
# );
# 
# http://msdn.microsoft.com/en-us/library/aa365488%28VS.85%29.aspx
#
############################################################# 


BOOL
RemoveDirectory( lpPathName )
    char * lpPathName
CODE:
    if ( RemoveDirectory(lpPathName) )
    {
        SetLastError(0) ;
        RETVAL = 0 ;
    }
    else
    {
        RETVAL = GetLastError() ;
    }
OUTPUT:
  RETVAL
  

#############################################################
#
# BOOL WINAPI DeleteFile(
#   __in  LPCTSTR lpFileName
# );
# 
# http://msdn.microsoft.com/en-us/library/aa363915%28VS.85%29.aspx
#
############################################################# 


DWORD
DeleteFile( lpFileName )
    char * lpFileName 
CODE:
    if ( DeleteFile(lpFileName) )
    {
        SetLastError(0) ;
        RETVAL = 0 ;
    }
    else
    {
        RETVAL = GetLastError() ;
    }
OUTPUT:
  RETVAL   
  

