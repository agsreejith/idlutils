;+
;
;  NAME: 
;     WordToPDF
;
;  PURPOSE: 
;   
;
;  CATEGORY:
;      UTILITIES
;
;  CALLING SEQUENCE:
;
;      WordToPDF
;
;  INPUTS:
;
;  OPTIONAL INPUTS:
;
;  OUTPUTS:
;
;  OPTIONAL OUTPUTS:
;
;  KEYWORD PARAMETERS:
;    
;  EXAMPLE:
;      WordToPDF
;
;  MODIFICATION HISTORY:
;        c. Matt Giguere 2013.01.13 14:09:32
;
;-
pro wordtopdf, $
help = help, $
postplot = postplot, $
dir = dir

!p.color=0
!p.background=255
loadct, 39, /silent
usersymbol, 'circle', /fill, size_of_sym = 0.5

if keyword_set(help) then begin
	print, '*************************************************'
	print, '*************************************************'
	print, '        HELP INFORMATION FOR ddocu_text'
	print, 'KEYWORDS: '
	print, ''
	print, 'HELP: Use this keyword to print all available arguments'
	print, ''
	print, ''
	print, ''
	print, '*************************************************'
	print, '                     EXAMPLE                     '
	print, "IDL>"
	print, 'IDL> '
	print, '*************************************************'
	stop
endif

if ~keyword_set(dir) then dir = '/Users/matt/Dropbox/ASTRO135/HW10/HW10'
spawn, 'ls -1 '+dir+'/*/*/*.doc', docfiles
spawn, 'ls -1 '+dir+'/*/*/*.docx', docxfiles
spawn, 'ls -1 '+dir+'/*/*/*.rtf', rtffiles
spawn, 'ls -1 '+dir+'/*/*/*.txt', txtfiles
files = [docfiles, docxfiles, rtffiles, txtfiles]
if docfiles[0] ne '' then begin 
files = docfiles 
if docxfiles[0] ne '' then files = [files, docxfiles]
endif else files = docxfiles
if rtffiles[0] ne '' then files = [files, rtffiles]
if txtfiles[0] ne '' then files = [files, txtfiles]

nfiles = n_elements(files)
fdir = strarr(nfiles)
pdfnm = strarr(nfiles)
for i=0, nfiles-1 do begin
  espot = strpos(files[i], '/', /reverse_search)
  pspot = strpos(files[i], '.', /reverse_search)
  ;print, pspot
  fdir[i] = strmid(files[i], 0, espot+1)
  pdfnm[i] = strmid(files[i], espot+1, pspot-espot-1)+'.pdf'
endfor
print, '*************************************************'
print, 'FILES TO CONVERT:'
print, '*************************************************'
print, [transpose(files)]
print, '*************************************************'
print, '# of files: ', n_elements(files)
stop
print, 'NOW CONVERTING...'

for i=0, nfiles-1 do begin
;spawn, 'osascript ~/Library/Scripts/PagesPDF.scpt "'+files[i]+'" "'+fdir[i]+pdfnm[i]+'"'
print, strt(i),' of ',strt(nfiles),': ', files[i], ' ',$
	strt(double(i)/nfiles*100d, f='(F8.1)'),'% complete.'
spawn, 'open -a WordtoPDF "'+files[i]+'"'
;wait, 5
stop
endfor

print, 'Finished at ', systime()
end;WordToPDF.pro