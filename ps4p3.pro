pro ps4p3
;PURPOSE: To calculate the population of CO and other 
;linear molecules in a particular state
;2010.04.08 ~MJG
h = planckc(/Js) ;Joules Seconds
BCO = 57.636d9 ;Hz
k = boltzc(/JK) ;Joules/Kelvin

;********************************************************
;The first state of CO at 10K:
T=10d;K

;Calculate the partition function:
Z = 0d
!p.font=0

zfin = 3.9680340d
for ji=0ll, 100 do begin
	Z += (2d*ji + 1)*$
	exp(-1d * h*BCO*ji*(ji+1d)/(k*T))
endfor

print, '************ CO T=10K BELOW *******************'

nstates=10
NJarr = dblarr(nstates)
for JJ=0, nstates-1 do begin
	Er = h*BCO*JJ*(JJ+1d)/(k*T)
	gfac = 2d * JJ + 1d
	NJarr[JJ] = gfac/Z * exp(-Er)
	print, 'JJ state: ', NJarr[JJ]
endfor

;*********************************************************
print, '************CO T=100K BELOW *******************'
;The first state of CO at 100K:
T=100d;K

;Calculate the partition function:
Z = 0d

zfin = 36.487321d
for ji=0d, 1d3 do begin
	Z += (2d*ji + 1)*$
	exp(-1d * h*BCO*ji*(ji+1d)/(k*T))
endfor

nstates=20
NJarr = dblarr(nstates)
for JJ=0, nstates-1 do begin
	Er = h*BCO*JJ*(JJ+1d)/(k*T)
	gfac = 2d * JJ + 1d
	NJarr[JJ] = gfac/Z * exp(-Er)
	print, 'JJ state: ', NJarr[JJ]
endfor
ps_open, 'p3plots/hist2', /encaps, /color
plothistogram, NJarr, yrng=[0,0.2], $
background=255, color=0, barnames=strt(indgen(nstates)), $
xtitle='J', ytitle='Probability of State'
ps_close

;********************************************************
print, '************CS T=10K BELOW *******************'
;The first state of CS at 10K:
BCS=24.584d9 ;Hz
T=10d;K

;Calculate the partition function:
Z = 0d

for ji=0d, 1d2 do begin
	Z += (2d*ji + 1)*$
	exp(-1d * h*BCS*ji*(ji+1d)/(k*T))
endfor

nstates=15
NJarr =dblarr(nstates)
for JJ=0, nstates-1 do begin
	Er = h*BCS*JJ*(JJ+1d)/(k*T)
	gfac = 2d * JJ + 1d
	NJarr[JJ] = gfac/Z * exp(-Er)
	print, 'JJ state: ', NJarr[JJ]
endfor


ps_open, 'p3plots/hist3', /encaps, /color
plothistogram, NJarr, yrng=[0,0.3], $
background=255, color=0, barnames=strt(indgen(nstates)), $
xtitle='J', ytitle='Probability of State'
ps_close

;********************************************************
print, '************HC11N T=10K BELOW *******************'
;The first state of CS at 10K:
BHCN=169.06295d9 ;Hz
T=10d;K

;Calculate the partition function:
Z = 0d
zfin = 1.6309166d
for ji=0d, 1d3 do begin
	Z += (2d*ji + 1)*$
	exp(-1d * h*BHCN*ji*(ji+1d)/(k*T))
endfor

nstates=5
NJarr=dblarr(nstates)
for JJ=0, nstates-1 do begin
	Er = h*BHCN*JJ*(JJ+1d)/(k*T)
	gfac = 2d * JJ + 1d
	NJarr[JJ]  = gfac/Z * exp(-Er)
	print, 'JJ state: ', NJarr[JJ] 
endfor
end;ps4p3.pro