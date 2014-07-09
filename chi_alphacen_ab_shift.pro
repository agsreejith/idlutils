;+
;
;  NAME: 
;     chi_alphacen_ab_shift
;
;  PURPOSE: 
;   
;
;  CATEGORY:
;      CHIRON
;
;  CALLING SEQUENCE:
;
;      chi_alphacen_ab_shift
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
;      chi_alphacen_ab_shift
;
;  MODIFICATION HISTORY:
;        c. Matt Giguere 2012.10.11 11:37:43 AM
;
;-
pro chi_alphacen_ab_shift, $
help = help, $
postplot = postplot

!p.color=0
!p.background=255
loadct, 39, /silent
usersymbol, 'circle', /fill, size_of_sym = 0.5

if keyword_set(help) then begin
	print, '*************************************************'
	print, '*************************************************'
	print, '        HELP INFORMATION FOR chi_alphacen_ab_shift'
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
window, xsize=2500, ysize = 800, xpos=0, ypos=1800
thick, 2
date='120606'
ima =readfits('/tous/mir7/fitspec/'+date+'/achi'+date+'.'+'1125.fits')
imb =readfits('/tous/mir7/fitspec/'+date+'/achi'+date+'.'+'1137.fits')
nspeca = dblarr(n_elements(ima[1,*,0]), n_elements(ima[1,0,*]))
nspecb = dblarr(n_elements(ima[1,*,0]), n_elements(ima[1,0,*]))
ccshiftarr = dblarr(62)
meanwavl = dblarr(62)
!p.multi=[0,1,2]
for ord=0, 61 do begin
if keyword_set(postplot) then begin
   fn = nextnameeps('ACenAB_CCX_plot')
;   thick, 2
   ps_open, fn, /encaps, /color
endif

;ord=2
  wava = ima[0, *, ord]
  speca = ima[1,*,ord]
  wavb = imb[0, *, ord]
  specb = imb[1,*,ord]
  rdsk, flat, '/tous/mir7/flats/chi'+date+'.narrow.flat'
  ford = 61 - ord
  continuum = reverse(flat[*,ford,2])
  nconta = continuum/max(continuum)*max(speca)
  ncontb = continuum/max(continuum)*max(specb)
  ;oplot, wav, ncont, col=250
  ;plot, wav, spec/ncont, /xsty
  nspeca[*,ord] = speca/nconta
  nspecb[*,ord] = specb/ncontb
  speca = nspeca[*,ord]
  specb = nspecb[*,ord]
;  x = where(wav gt 4617d and wav lt 4629d)
  plot, wavb, specb, /xsty, /ysty, $
  xtitle='Wavelength [A]', ytitle='Normalized Flux';, xrang=[4615, 4625d]
  oplot, wava, speca, col=250
  al_legend, ['A Cen A', 'A Cen B'], colors=['red', 'black'], /bottom, /right, linestyle=[0,0]
  ccshift = cross_correlate(wava, speca, wavb, specb, oversample=10, /spline)
  print, 'ccshift is: ', ccshift
  ccshiftarr[ord] = ccshift
  meanwavl[ord] = median(wavb)
if keyword_set(postplot) then begin
   ps_close
endif

endfor  

!p.multi=[0,1,1]
if keyword_set(postplot) then begin
   fn = nextnameeps('ACenAB_CCX_Ashift')
;   thick, 2
   ps_open, fn, /encaps, /color
endif

plot, meanwavl, ccshiftarr, ps=8, $
xtitle='Mean Wavelength For Order', $
ytitle='Shift in Angstroms'
if keyword_set(postplot) then begin
   ps_close
endif


if keyword_set(postplot) then begin
   fn = nextnameeps('ACenAB_CCX_RV')
;   thick, 2
   ps_open, fn, /encaps, /color
endif
plot, meanwavl, ccshiftarr/meanwavl*2.99792458d8, ps=8, yran=[-2000,-1000], /ysty, $
xtitle='Mean Wavelength For Order', $
ytitle='Velocity [m/s]'
if keyword_set(postplot) then begin
   ps_close
endif

velarr = ccshiftarr/meanwavl*2.99792458d8
x = where(velarr le -1500)
print, 'Median velocity [m/s]: ', median(velarr)
print, 'Median velocity [m/s] (after cut): ', median(velarr[x])


stop
end;chi_alphacen_ab_shift.pro