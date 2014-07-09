;+
;
;  NAME: 
;     read_dartmouth_iso
;
;  PURPOSE: 
;   
;
;  CATEGORY:
;      UTILITIES
;
;  CALLING SEQUENCE:
;
;      read_dartmouth_iso
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
;      read_dartmouth_iso
;
;  MODIFICATION HISTORY:
;        c. Matt Giguere 2012.08.24 03:06:23 PM
;
;-
pro read_dartmouth_iso, $
help = help, $
postplot = postplot

!p.color=0
!p.background=255
loadct, 39, /silent
usersymbol, 'circle', /fill, size_of_sym = 0.5

if keyword_set(help) then begin
	print, '*************************************************'
	print, '*************************************************'
	print, '        HELP INFORMATION FOR read_dartmouth_iso'
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

openr, fu, '~/Downloads/tmp1345834622.txt', /get_lun
;the line number to start on (as displayed in textwrangler):
;make this the line number displaying the first set of numbers
line=''
readf, fu, line
;number of ages in evolutionary tracks
nages = strsplit(line, '=', /extract)
nages = nages[1]
for i=0, 5 do begin
  readf, fu, line
  print, line
endfor

;number of stars in evolutionary tracks:
nstars = 280
ages = dblarr(nages)
masses = dblarr(nages, nstars)
temps = dblarr(nages, nstars)
grav = dblarr(nages, nstars)
lum = dblarr(nages, nstars)
bmag = dblarr(nages, nstars)
vmag = dblarr(nages, nstars)
rmag = dblarr(nages, nstars)
imag = dblarr(nages, nstars)

;here's the first age:
readf, fu, line
ageline = strsplit(line, /extract)
ages[0] = ageline[1]
ageidx = 0
;skip the column labels:
readf, fu, line

; While there is text left, output it:
WHILE ~ EOF(fu) DO BEGIN
   line=''
   READF, fu, line
   ;stop
   line = strsplit(line, ' ', /extract)
   print, line
   if strt(line[0]) ne '' then begin
     print, 'now recording.'
	 masses[ageidx, long(line[0])] = double(line[1])
	 temps[ageidx, long(line[0])] = double(line[2])
	 grav[ageidx, long(line[0])] = double(line[3])
	 lum[ageidx, long(line[0])] = double(line[4])
	 bmag[ageidx, long(line[0])] = double(line[5])
	 vmag[ageidx, long(line[0])] = double(line[6])
	 rmag[ageidx, long(line[0])] = double(line[7])
	 imag[ageidx, long(line[0])] = double(line[8])
   endif else begin
	 ageidx++
	 ;new age:
	 READF, fu, line
	 READF, fu, line
	 ageline = strsplit(line, ' ', /extract)
	 ages[ageidx] = ageline[1]
	 READF, fu, line
   endelse

ENDWHILE

plot, findgen(50), xtitle='B-V', ytitle='V', yran=[15,-5], xran=[0,2], /xsty, /ysty, /nodata
for i=3, 279 do begin
x = where(bmag[*,i] ne 0 and vmag[*,i] ne 0)
oplot, bmag[x,i]-vmag[x,i], vmag[x,i], col=i
;wait, 0.5
endfor
if keyword_set(postplot) then begin
   fn = nextnameeps('plot')
   thick, 2
   ps_open, fn, /encaps, /color
endif

if keyword_set(postplot) then begin
   ps_close
endif

stop
end;read_dartmouth_iso.pro