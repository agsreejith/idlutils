;+
;
;  NAME: 
;     cross_correlate
;
;  PURPOSE: To find the cross correlation between 2 functions
;   
;
;  CATEGORY:
;      UTILITIES
;
;  CALLING SEQUENCE:
;
;      cross_correlate
;
;  INPUTS:
;	X1: The ordinates of the first function
;	Y1: The abscissa of the first function
;	X2: The ordinates of the second function
;	Y2: The abscissa of the second function
;
;  OPTIONAL INPUTS:
;	OVERSAMPLE: If you want to oversample, use this keyword
;
;  OUTPUTS:
;	XOUT: The oversampled and interpolated ordinates
;	YOUT1: The oversampled and interpolated abscissa for the first function
;	YOUT2: The oversampled and interpolated abscissa for the second function
;
;  OPTIONAL OUTPUTS:
;	LAGARR: All the steps taken in lag
;	COR_RES: The Cross correlation function.
;
;  KEYWORD PARAMETERS:
;    
;  EXAMPLE:
;      difference = cross_correlate(x1, y1, x2, y2, oversample=10, /plot)
;
;  MODIFICATION HISTORY:
;        c. Matt Giguere 2012.10.10 12:39:34 PM
;			added lagarr and cor_res as output 2013.05.23 ~MJG
;		
;
;-
function cross_correlate, $
help = help, $
postplot = postplot, $
x1, y1, x2, y2, $
oversample=oversample, $
spline = spline, $
quadratic = quadratic, $
plot = plot, $
xout = xout, $
yout1 = yout1, $
yout2 = yout2, $
lagarr = lagarr, $
cor_res = cor_res


!p.color=0
!p.background=255
loadct, 39, /silent
usersymbol, 'circle', /fill, size_of_sym = 0.5

;first find out which function has the higher resolution:
r1 = x1[1]-x1[0]
r2 = x2[1] - x2[0]
if r2 le r1 then begin
;function 2 has the higher definition
xhd = x2 & yhd = y2
xld = x1 & yld = y1
endif else begin
;function 1 has the higher definition
xhd = x1 & yhd = y1
xld = x2 & yld = y2
endelse
;now to treat oversampling:
if ~keyword_set(oversample) then oversample = 1d
;nouthd = number of elements in the oversampled output array:
nouthd = n_elements(xhd)*oversample
xouthd = (max(xhd) - min(xhd))/nouthd * dindgen(nouthd) +$
min(xhd)
;print, 'minmax of xouthd: ', minmax(xouthd)
youthd = interpol(yhd, xhd, xouthd, spline=keyword_set(spline), quadratic=keyword_set(quadratic))
youtld = interpol(yld, xld, xouthd, spline=keyword_set(spline), quadratic=keyword_set(quadratic))
;plot, xouthd, youthd, /xsty
;oplot, xouthd, youtld, col=250
xout = xouthd
if r2 le r1 then yout2 = youthd else yout1 = youthd
if r2 le r1 then yout1 = youtld else yout2 = youtld


;± percent range: 
percrange = 0.1
lagarr = round(dindgen(2*percrange*n_elements(xouthd)) - percrange*n_elements(xouthd))

cor_res = c_correlate(youtld, youthd, lagarr, /double)
x = where(cor_res eq max(cor_res))
;print, 'The max lag was: ', lagarr[x]
;print, 'This corresponds to: ', lagarr[x]*(xouthd[1] - xouthd[0])

if keyword_set(plot) then begin
  plot, lagarr, cor_res, /xsty, xtitle='Lag', ytitle='Cross Correlation', ps=-8
  stop
endif


return, lagarr[x]*(xouthd[1] - xouthd[0])
end;cross_correlate.pro