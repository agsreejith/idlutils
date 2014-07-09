;+
;
;  NAME: 
;     stellar_parameters
;
;  PURPOSE: 
;   
;
;  CATEGORY:
;      UTILITIES
;
;  CALLING SEQUENCE:
;
;      stellar_parameters
;
;  INPUTS:
;
;  OPTIONAL INPUTS:
;
;  OUTPUTS: To print the stellar parameters for a given star.
;
;  OPTIONAL OUTPUTS:
;
;  KEYWORD PARAMETERS:
;    
;  EXAMPLE:
;      stellar_parameters
;
;  MODIFICATION HISTORY:
;        c. Matt Giguere 2012.08.16 06:00:47 PM
;
;-
pro stellar_parameters, $
help = help, $
postplot = postplot, $
hd = hd

!p.color=0
!p.background=255
loadct, 39, /silent
usersymbol, 'circle', /fill, size_of_sym = 0.5

if keyword_set(help) then begin
	print, '*************************************************'
	print, '*************************************************'
	print, '        HELP INFORMATION FOR stellar_parameters'
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

restore, '/home/matt/idl/data/hip.dat'
restore, '/home/matt/idl/data/hip2.dat'
hd = strt(long(hd))
hipx = where(hip.hd eq hd)
hip2x = where(hip2.hd eq hd)
if hipx eq -1 or hipx eq '' then begin
  print, 'WARNING! Your star was not in the Hipparcos catalog!'
  stop
endif
print, '*************************************************'
print, 'HD '+strt(hd)+' | '+'HIP '+strt(hip[hipx].hipno)
print, '*************************************************'
;van Leeuwen 2008 (hip2) uses an odd band specific to hipparcos that's
;not the common Johnson V band. The hip (ESA 1997) V band is 
;the Johnson V Band (i.e. the one you want to reference):
print, 'v mag from hip: ', hip[hipx].vmag
;van Leeuwen parallax measurements are more accurate:
distance = 1d3 / hip2[hip2x].prlax
absM = hip[hipx].vmag - 5d * alog10(distance) + 5
print, 'absolute V mag from hip v mag and hip2 parallax: ', absM
print, 'B-V from hip: ', hip[hipx].b_v
;d[pc] = 1/p["], but prlax is in mas, hence the 1d3:
print, 'distance from hip2 [pc]: ', distance
;err_d = abs(dd/dp) * err_p
; = abs(-1 * p^-2)*err_p:
print, 'dist_unc from hip2 [pc]: ', abs(1d3/hip2[hip2x].prlax)^2*(hip2[hip2x].prlaxerr * 1d-3)
print, 'parallax from hip2[mas]: ', hip2[hip2x].prlax
print, 'par_unc from hip2[mas]: ', hip2[hip2x].prlaxerr




stop
end;stellar_parameters.pro