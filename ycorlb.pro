pro  ycorlb, star,temp,shft,$
plot=plot, $
nsteps = nsteps, $
stepsize = stepsize
 
; cross correlates in the y direction to get the 
; best offset to match continuum.
;
; assumes that xcorlb has already run to match up spectra
; in wavelength.

;	input	star	star, with central line cut out
;		temp	template, with central line cut out

;	output	shft	the vertical shift to be added to star

; Fischer 9-17-99
; MJG: 2012.10.14 Made nsteps and step size variable, and made 
;		the routine more efficient.

if n_params() lt 3 then begin
   print,'YCORLB, fixed,test,shft[,plot=plot]' &
   print, 'Uses spline to find extremum'   
return
endif
     
if ~keyword_set(nsteps) then nsteps=40
if ~keyword_set(stepsize) then stepsize = 1d / (nsteps * 2d)
step=dindgen(nsteps+1)*stepsize - nsteps*stepsize/2d + 1d
;print, minmax(step)
;stop

chi = dblarr(nsteps)

for j = 0, nsteps-1 do begin  
   shftstar = star * step[j]
   chi[j] = sqrt(total((temp - shftstar)^2d))
endfor

bestshift = where(chi eq min(chi))
;print, 'bestshift is: ', bestshift
shft=step[bestshift]

if keyword_set(plot) then begin
    plot,star+shft
;     plot, step, chi, ps=8
print, 'best continuum shift: ',shft
endif

end

