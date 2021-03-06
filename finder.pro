;***********************************************************************
; NAME: 	FINDER.PRO
;																	   
; PURPOSE:    To show the desired procedure in Finder.app
;																	   
; CATEGORY: EXOPLANETS							   
;																	   
; CALLING SEQUENCE:													   
;	finder, 'finder																	   
;																	   
; INPUTS:															   
;	NAME: A string containing the name of the file you want to
;		show in Finder.app
;
; OPTIONAL INPUTS:	NONE												   
;																	   
; KEYWORD PARAMETERS:	NONE											   
;																	   
; OUTPUTS:	shows the desired procedure in Finder.app														   
;																	   
; OPTIONAL OUTPUTS:	NONE												   
;																	   
; COMMON BLOCKS:	NONE												   
;																	   
; SIDE EFFECTS: NONE														   
;																	   
; RESTRICTIONS:		NONE												   
;																	   
; PROCEDURE:														   
;																	   
; EXAMPLE:															   
;	finder, 'plot
;
; MODIFICATION HISTORY:												   
;		adapted from WRANGLE.PRO:
;     c. Matt Giguere, Saturday, October 30, 2010
;***********************************************************************

;From somewhere else:
FUNCTION GREP, str, strarray, sensitive=sensitive, exact=exact, index=index,$
               exclude=exclude, start=start

   sz=size(str)
   dtype=sz(n_elements(sz)-2)
   sz=size(strarray)
   stype=sz(n_elements(sz)-2)

   IF (dtype ne 7) OR (stype ne 7) THEN BEGIN
      MESSAGE, 'Input parameter must be of string type.', /cont
      RETURN, ''
   ENDIF

   aa = strtrim(strarray,2)
   a = strtrim(str,2)
   start=KEYWORD_SET(start)
   exact=KEYWORD_SET(exact)

   IF NOT KEYWORD_SET(sensitive) THEN BEGIN
    aa = STRUPCASE(aa)
    a = STRUPCASE(a)
   ENDIF

   IF KEYWORD_SET(exclude) THEN BEGIN 
    IF exact THEN index = WHERE(aa NE a) ELSE $
     index = WHERE(STRPOS(aa, a) EQ -1)
   ENDIF ELSE BEGIN 
    IF exact THEN index = WHERE(aa EQ a) ELSE BEGIN
     IF start then index=WHERE(STRPOS(aa,a) eq 0) ELSE $
      index = WHERE(STRPOS(aa, a) NE -1)
    ENDELSE
   ENDELSE

;---------------------------------------------------------------------------
;        Make sure the returned values are of scalar type
;---------------------------------------------------------------------------

   IF index(0) GE 0 THEN BEGIN
    IF N_ELEMENTS(index) EQ 1 THEN BEGIN
     index = index(0)
     RETURN, (strarray(index))(0)
    ENDIF ELSE RETURN, strarray(index)
   ENDIF ELSE BEGIN
    index = -1
    RETURN, ''
   ENDELSE

   END
function OS_FAMILY
;+
; NAME:
;	OS_FAMILY
; PURPOSE:
;	Return the current operating system as in !VERSION.OS_FAMILY 
;
; CALLING SEQUENCE
;	result = OS_FAMILY()
; INPUTS: 
;	None
; OUTPUTS:
;	result - scalar string containing one of the four values
;		'Windows','MacOS','vms' or 'unix'
; NOTES:
;	OS_FAMILY is assumed to be 'unix' if !VERSION.OS is not 'windows',
;		'MacOS' or 'vms'
;
;	To make procedures from IDL V4.0 and later compatibile with earlier
;	versions of IDL, replace calls to !VERSION.OS_FAMILY with OS_FAMILY().	
;
; PROCEDURES CALLED
;	function TAG_EXISTS()
; REVISION HISTORY:
;	Written,  W. Landsman     
;-
 if tag_exist(!VERSION, 'OS_FAMILY') then return, !VERSION.OS_FAMILY

 case !VERSION.OS of

'windows': return, 'Windows'
  'MacOS': return, 'MacOS'
    'vms': return, 'vms'
     else: return, 'unix'

 endcase

 end


PRO WHICH, name, all=all, search=search, outfile=outfile,quiet=quiet
;+
; PROJECT:
;       SOHO - CDS
;
; NAME:
;       WHICH
;
; PURPOSE:
;       Search for and print file or routine in IDL !path
;
; EXPLANATION:
;       Use to find where IDL finds a program file, and, if
;	multiple definitions exist, which is loaded (the first
;	one). Splits path into all different directories,
;	searches for a file with the given NAME + '.PRO'.
;
; CALLING SEQUENCE:
;       WHICH, NAME
;
; INPUTS:
;       NAME - Name of the routine to search for (string scalar).
;
; OPTIONAL INPUTS:
;       None.
;
; OUTPUTS:
;       None.
;
; OPTIONAL OUTPUTS:
;       outfile - return file name found
;
; KEYWORD PARAMETERS:
;       ALL    - Report all occurrences if set. Usually WHICH reports the
;                first occurrence of a found routine (which is to be
;                executed by IDL). WHICH can take a while, especially on
;                VMS system, to search through all directories (and text
;                libraries on VMS system) if ALL is set. ALL is
;                automatically set if SEARCH is set.
;       SEARCH - Turn on the search mode, if set, that would match any
;                given string pattern found in the path.
;
; CALLS:
;       CONCAT_DIR, STR_CHOP, GREP
;
; COMMON BLOCKS:
;       WHICH -- Mainly for speeding things up
;
; RESTRICTIONS:
;       None.
;
; SIDE EFFECTS:
;       None.
;
; CATEGORY:
;       General utility
;
; PREVIOUS HISTORY:
;       Written Stein Vidar Haugan, 1993
;
; MODIFICATION HISTORY:
;       19 May, 1994, SVHH, Doc. added
;	21 May, 1994, SVHH, Version 2, with on_error,2 and 'Use:'
;       Liyun Wang, GSFC/ARC, September 20, 1994
;          Added IDL internal routine checkings.
;       Liyun Wang, GSFC/ARC, October 5, 1994
;          Current directory also gets searched now
;       Version 3, Liyun Wang, GSFC/ARC, December 16, 1994
;          Made it capable of finding files in text libraries on VMS system
;          Added the ALL keyword
;       Version 4, Liyun Wang, GSFC/ARC, January 23, 1995
;          Added the SEARCH keyword
;       Version 5, Liyun Wang, GSFC/ARC, January 24, 1995
;          Used an undocumented IDL function routine ROUTINE_NAMES to get IDL
;             intrinsic routine names.
;       Version 6, Liyun Wang, NASA/GSFC, October 1, 1996
;          Added Windows support
;       Version 7 Add output variable.  CDP, RAL 14-Mar-97
;	Version 8, 23-Oct-1997, William Thompson, GSFC
;		Use OS_FAMILY() instead of !VERSION.OS
;	Version 9, 4-July-1998, Zarro (SAC/GSFC)
;               Returned scalar out variable for single element value
;       Version 10, 28-Jun-1999, Zarro (SM&A/GSFC)
;               Added /quiet 
;
; VERSION:
;       Version 9
;-

   COMMON which, internal
   ON_ERROR,2
   loud=1-keyword_set(quiet)

;----------------------------------------------------------------------
;  A list of IDL internal routine can be obtained by entering the "?"
;  command at IDL prompt, provided that the current device is set to
;  'tek'.
;----------------------------------------------------------------------

   IF N_ELEMENTS(name) EQ 0 THEN BEGIN
      PRINT, 'WHICH -- Syntax error.'
      PRINT, '   Usage: WHICH, ''filename'' [,/ALL, file=file]'
      PRINT, ' '
      RETURN
   ENDIF

;
;  keep an array of the answers
;
outfile = ''

;----------------------------------------------------------------------
;  In case a file name with an extension is entered, strip off the
;  extension:
;----------------------------------------------------------------------
   ipos =  STRPOS(name,'.')
   IF (ipos NE -1) THEN name = STRMID(name,0,ipos)
   cd,current = cur_dir

   CASE os_family() OF
      'vms': path_sep = ','
      'Windows': path_sep = ';'
      ELSE: path_sep = ':'
   ENDCASE

;----------------------------------------------------------------------
;  First check to see if it is an IDL internal routine. We will call an
;  undocumented IDL function called ROUTINE_NAMES to get all names of
;  the IDL built-in function and procedure names.
;----------------------------------------------------------------------
   IF N_ELEMENTS(internal) EQ 0 THEN BEGIN
      f_name = ROUTINE_NAMES(/s_functions)
      p_name = ROUTINE_NAMES(/s_procedures)
      internal = [f_name, p_name]
   ENDIF
   IF KEYWORD_SET(search) THEN BEGIN
      exact = 0
      all = 1
      ff = grep(name, internal)
      IF ff(0) NE '' THEN BEGIN
         temp = arr2str(ff,', ')
         if loud then PRINT, 'IDL Built-in: ',temp
         outfile = [outfile,'IDL Built-in: '+temp]
      ENDIF
   ENDIF ELSE BEGIN
      exact = 1
      aa = WHERE(STRUPCASE(name) EQ internal, count)
      IF count NE 0 THEN BEGIN
         if loud then PRINT, STRUPCASE(name)+' is an IDL built-in routine.'
         outfile = [outfile,STRUPCASE(name)+' is an IDL built-in routine.']
         IF N_ELEMENTS(all) EQ 0 THEN begin
            if n_elements(outfile) gt 1 and outfile(0) eq '' then $
               outfile = outfile(1:*)
            RETURN
         ENDIF
      ENDIF
   ENDELSE

   p = cur_dir+path_sep+!path
   dirs = str_sep(p,path_sep)

   CASE (!version.os) OF
      'vms': BEGIN
         FOR i = 0,N_ELEMENTS(dirs)-1 DO BEGIN
            allfiles = str_chop(STRUPCASE(get_mod(dirs(i))),'.PRO')
            ff = grep(name, allfiles, exact=exact)
            IF (ff(0) NE '') THEN BEGIN
               FOR j = 0, N_ELEMENTS(ff)-1 DO BEGIN
                  filename = concat_dir(dirs(i),ff(j))
                  if loud then PRINT, filename+'.PRO'
                  outfile = [outfile,filename+'.PRO']
               ENDFOR
               IF N_ELEMENTS(all) EQ 0 THEN GOTO, cleanup
            ENDIF
         ENDFOR
cleanup:
;----------------------------------------------------------------------
;        Clean up scratch files when library is listed
;----------------------------------------------------------------------
         look = findfile('sys$login:*._sdac_*;*',count=nf)
         IF nf GT 0 THEN BEGIN
            FOR i=0,nf-1 DO BEGIN
               spawn,'DELETE/NOLOG/NOCONFIRM '+look(i)
            ENDFOR
         ENDIF
      END
      ELSE: BEGIN
         IF KEYWORD_SET(search) THEN BEGIN
            FOR i = 0, N_ELEMENTS(dirs)-1 DO BEGIN
               filename = findfile(concat_dir(dirs(i),'*'+name+'*.pro'),$
                           count = cnt)
               IF cnt GT 0 THEN BEGIN
                  FOR j = 0, cnt-1 DO begin
                     if loud then PRINT, filename(j)
                     outfile = [outfile,filename(j)]
                  endfor
               ENDIF
            ENDFOR
         ENDIF ELSE BEGIN
            FOR i = 0,N_ELEMENTS(dirs)-1 DO BEGIN
               filename = concat_dir(dirs(i),name+'.pro')
               OPENR, unit, filename, /GET_LUN, error=rr
               IF rr EQ 0 THEN BEGIN
                  if loud then PRINT, filename
                  outfile = [outfile,filename]
                  CLOSE, unit
                  FREE_LUN, unit
                  IF NOT KEYWORD_SET(all) THEN BEGIN
                     if n_elements(outfile) gt 1 and outfile(0) eq '' then $
                          outfile = outfile(1:*)
                     RETURN
                  ENDIF
               ENDIF
            ENDFOR
         ENDELSE
      END
   ENDCASE
;
;  tidy up output variable
;
if n_elements(outfile) gt 1 and outfile(0) eq '' then outfile = outfile(1:*)
if n_elements(outfile) eq 1 then outfile=outfile(0)

END

pro finder, name
	which, name, outfile = ofn
	spawn, 'open -R '+ofn
end ;finder.pro