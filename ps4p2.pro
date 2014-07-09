pro ps4p2
;PURPOSE: To calculate the gas mass of B5.
;2010.04.16 ~MJG

;This is the efficiency of the telescope. It states
;that the antenna temperature is roughly half the
;brightness temperature:
eta = 0.5d

;read in the data cubes:
im12 = readfits('b5_12co.fits', h12, /nanvalue)/eta
im13 = readfits('b5_13co.fits', h13, /nanvalue)/eta

;create the x-axis from the header information:
naxis3=630 ;number of elements
deltav12 = 0.06350219d
vinit12=-9.96994676355d
velarr12=deltav12*dindgen(naxis3) + vinit12

deltav13 = 0.06350219d
vinit13=-9.958880321302d
velarr13=deltav13*dindgen(naxis3) + vinit13

im12reg = im12[56:85,17:36,*]
im13reg = im13[56:85,17:36,*]

avgarr12=dblarr(630) & avgarr13=dblarr(630)
for z=0, 629 do begin
	avgarr12[z] = mean(im12[56:85,17:36,z])
	avgarr13[z] = mean(im13[56:85,17:36,z])
endfor

loadct, 39, /silent
plot, velarr12, avgarr12, ps=8, $
xtitle='V (km s!u-1!n)', $
ytitle='T!dB!n (K)'
oplot, velarr13, avgarr13, ps=8, color=125
legend, ['!u13!nCO', '!u12!nCO'], psym=[8,8], colors=[125,0]

T_0 = 5.29d
T_peak = max(avgarr13)
T_ex = 5.53d / ( alog(1d + 5.53/ (T_peak + 0.82))) 

tau13 = -1d * alog(1d - im13/(T_0/(exp(T_0/T_ex) - 1d) - 0.87d))

T_peak12 = max(avgarr12)
T_012 = 5.5d
T_ex12 = 5.53d / ( alog(1d + 5.53/ (T_peak12 + 0.82))) 

xlength = 30 * 46 / 3600d
ylength = 20 * 46 / 3600d
areaster = xlength*ylength / 3283d

;***********************************************************************
;i.  12CO is optically thin. 

;First calculate the max beam temperature for each element over the entire
;velocity range:
xran = 85-56+1
yran = 36-17+1
tmaxarea12 = dblarr(xran, yran)
tmaxarea13 = dblarr(xran, yran)
for xx=56, 85 do begin
for yy=17, 36 do begin
   tmaxarea12[xx-56,yy-17] = total(im12[xx,yy,*])
   tmaxarea13[xx-56,yy-17] = total(im13[xx,yy,*])
endfor
endfor
NCOL13 = 3d14*tmaxarea13/(1d - exp(-1d * T_0/T_ex))
NCOL12 = 3d14*tmaxarea12/(1d - exp(-1d * T_012/T_ex12))

;The mass in solar masses from Yu et al 1999 (A1) in Solar Masses:
pxinster = (46d / 3600d)^2 / 3283d

Mxy12 = 1.54d-10*NCOL12/62d *pxinster
Mxy13 = 1.54d-10*NCOL13 *pxinster 
print, '***************************************'
print, 'i. total mass from 12: ', total(Mxy12)
print, 'ii. total mass from 13: ', total(Mxy13)

;iii. NOW FOR THE CONSTANT CASE:
TAU = 1D
taufac = tau/(1d - exp(-1d * tau))
NCOL13 = 3d14*tmaxarea13/(1d - exp(-1d * T_0/T_ex))*taufac
Mxy13c = 1.54d-10*NCOL13 *pxinster 
print, 'iii. constant tau total mass: ', total(Mxy13c)

;iv. FOR THE TAU AS A FUNCTION OF VELOCITY:
;approximate the noise to be:
CO13noise = max(avgarr13[0:150])

;This picks out the high signal elements for 13CO
tau13vals = where(im13reg gt 2d*CO13noise)

;This picks out the low signal elements for 12CO
tau12vals = where(im13reg le 2d*CO13noise)

composite = dblarr(30, 20, 630)
composite[tau13vals] = im13[tau13vals]
composite[tau12vals] = im12[tau12vals]/62d

tau13 = -1d * alog(1d - composite/(T_0/(exp(T_0/T_ex) - 1d) - 0.87d))
;tau13[where(finite(tau13, /nan) eq 1)] = 0

N13v = 2.42d14 * (T_ex +0.88d)*tau13/(1d - exp(-1d * T_0/T_ex))*deltav13

Mxy13v = 1.54d-10*N13v *pxinster 

print, 'iv. opacity(v) total mass: ', total(Mxy13v)
print, '***************************************'

stop
end;ps4p2.pro
