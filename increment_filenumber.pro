;+
;;  NAME: 
;     increment_filenumber
;;  PURPOSE: 
;   
;
;  CATEGORY:
;      UTILITIES
;
;  CALLING SEQUENCE:
;
;      increment_filenumber
;
;  KEYWORD PARAMETERS:
;		STARNUM: The starting number of the set of files you want to increment the names of
;
;		ENDNUM: The ending number of the set of observations you want to increment the names of
;
;  OPTIONAL KEYWORD PARAMETERS:
;
;    
;  EXAMPLE:
;      increment_filenumber, startnum=3444L, endnum=3508L
;
;  MODIFICATION HISTORY:
;        c. Matt Giguere 2011.07.07 07:05:03 PM
;
;-
pro increment_filenumber, $
directory = directory, $
prefix = prefix, $
startnum = startnum, $
endnum = endnum, $
suffix = suffix, $
stepsz = stepsz

if ~keyword_set(directory) then directory = '/mir7/raw/110706/'
if ~keyword_set(prefix) then prefix = 'qa38.'


if ~keyword_set(suffix) then suffix = '.fits'
if ~keyword_set(stepsz) then stepsz = 1L

for i=0L, endnum - startnum do begin
comm='mv '+directory+prefix+strt(endnum - i)+suffix+' '+directory+prefix+strt(endnum +1L - i)+suffix
print, comm
spawn, comm
endfor

end;increment_filenumber.pro