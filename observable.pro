pro observable, $
printplot=printplot, $
resolution=resolution, $
observatory=observatory, $
moon=moon, $
minalt=minalt, $
no_transit=no_transit, $
transitjd=transitjd, $
transitunc=transitunc, $
transitdur=transitdur, $
orbitalper=orbitalper, $
output=output, $
perunc=perunc, $
hdnum=hdnum


;PURPOSE: DETERMINE IF AN OBJECT IS OBSERVABLE OVER A GIVEN TIME PERIOD. 

; OPTIONAL KEYWORDS:
;	PRINTPLOT: PRINT A COLOR ENCAPSULATED POSTSCRIPT PLOT INSTEAD
;       OF PRINTING TO SCREEN
;	RESOLUTION: The resolution (in minutes) used to calculate
;				the observability of the object of interest
;  OBSERVATORY: If you want to know where the object is visible, you can
;		either enter the LAT, LON of the location of interest, or the 
;       observatory abbreviation listed below
;
;	MOON: Overplot the phase of the moon in the background
;
;	MINALT: The minimum altitude above the horizon. The default is 30 deg
;
;	TRANSIT KEYWORDS:
;
;	TRANSITJD: The JD of center transit
;
;	TRANSITDUR: The total duration of transit (In hours)
;
;	TRANSITUNC: The semi-uncertainty of transit 
;			(transit center - begin window) in days
;
;	ORBITALPER: The orbital period used for overplotting additional 
;				transits in days
;
;   OUTPUT: This is an optional keyword that will output an array 
;     that's 365X(24 * 3600 / resolution), where resolution is the
;     resolution (in minutes) as described above. 
;
;	PERUNC: The uncertainty of the orbital period
;
;	HDNUM: The Henry Draper Number of the object used to retrieve the 
;		RA and DEC to determine observability




;   Observatory information is taken from noao$lib/obsdb.dat file in
;   IRAF 2.11
;   Currently recognized observatory names are as follows:
;
;  'kpno': Kitt Peak National Observatory
;  'ctio': Cerro Tololo Interamerican Observatory
;  'eso': European Southern Observatory
;  'lick': Lick Observatory
;  'mmto': MMT Observatory
;  'cfht': Canada-France-Hawaii Telescope
;  'lapalma': Roque de los Muchachos, La Palma
;  'mso': Mt. Stromlo Observatory
;  'sso': Siding Spring Observatory
;  'aao': Anglo-Australian Observatory
;  'mcdonald': McDonald Observatory
;  'lco': Las Campanas Observatory
;  'mtbigelow': Catalina Observatory: 61 inch telescope
;  'dao': Dominion Astrophysical Observatory
;  'spm': Observatorio Astronomico Nacional, San Pedro Martir
;  'tona': Observatorio Astronomico Nacional, Tonantzintla
;  'Palomar': The Hale Telescope
;  'mdm': Michigan-Dartmouth-MIT Observatory
;  'NOV': National Observatory of Venezuela
;  'bmo': Black Moshannon Observatory
;  'BAO': Beijing XingLong Observatory
;  'keck': W. M. Keck Observatory
;  'ekar': Mt. Ekar 182 cm. Telescope
;  'apo': Apache Point Observatory
;  'lowell': Lowell Observatory
;  'vbo': Vainu Bappu Observatory
;  'flwo': Whipple Observatory
;  'oro': Oak Ridge Observatory
;  'lna': Laboratorio Nacional de Astrofisica - Brazil
;  'saao': South African Astronomical Observatory
;  'casleo': Complejo Astronomico El Leoncito, San Juan
;  'bosque': Estacion Astrofisica Bosque Alegre, Cordoba
;  'rozhen': National Astronomical Observatory Rozhen - Bulgaria
;  'irtf': NASA Infrared Telescope Facility
;  'bgsuo': Bowling Green State Univ Observatory
;  'ca': Calar Alto Observatory
;  'holi': Observatorium Hoher List (Universitaet Bonn) - Germany
;  'lmo': Leander McCormick Observatory
;  'fmo': Fan Mountain Observatory
;  'whitin': Whitin Observatory, Wellesley College
;  'mgio': Mount Graham International Observatory
;
;   OTHER ADDITIONS:
;	'leitner': Yale Leitner Observatory in New Haven, CT, USA
;	'konkoly': Konkoly Obs. of the Hungary Academy of Sciences, Hungary
;	'bluesky': The Blue Sky Observatory in Durham, NH, USA
;
;c. 2010.04.07 ~MJG
; 2011.01.30: added output keyword ~MJG
;

if ~keyword_set(resolution) then resolution = 5d
if ~keyword_set(year) then year = 2012
output = dblarr(365, 24d*3600d / resolution)

;test: HD 163607 @ keck
if ~keyword_set(observatory) then obsnm = 'keck' else obsnm=observatory
observatory, obsnm, obs_struct
obsrvtrylat=obs_struct.latitude
obsrvtrylon=-obs_struct.longitude
obsrvtryalt=obs_struct.altitude
tzoff = -obs_struct.tz/24d

if ~keyword_set(hdnum) then begin
	objnm = 'HD163607'
	rah=17d
	ram=53d
	ras=40.5d
	rafull = (rah + ram/60d + ras/3600d)*15d
	
	decd=56d
	decm=23d
	decs=31d
	decfull= decd + decm/60d + decs/3600d
endif else begin
	restore, 'idl/exoidl/data/hdecat.dat'
	objnm='hd'+strt(hdecat[hdnum].hdnum)
	rafull = hdecat[hdnum].ra
	decfull = hdecat[hdnum].dec
	rah = floor(rafull/15d)
	ram = floor( (rafull/15d - rah)*60d )
	ras = floor( (rafull/15d - rah - ram/60d)*3600d )
	decd = floor(decfull)
	decm = floor((decfull - decd)*60d)
	decs = floor( (decfull - decd - decm/60d)*3600d)
endelse

print, 'ra full is: ', rafull
print, 'dec full is: ', decfull
print, 'ra: ', strt(rah), ' h ', strt(ram), ' min ', strt(ras), ' sec'
print, 'dec: ', strt(decd), ' deg ', strt(decm), ' min ', strt(decs), ' sec'
;stop


base=widget_base(xsize=50,ysize=30,title='status');, xoffset=600, yoff=50)
percent=widget_text(base, value='0 %')
draw=widget_draw(base,xsize=100,ysize=50, $
uvalue='draw')
state={base:base, percent:percent}
pstate = ptr_new(state, /no_copy, /allocate)

widget_control,base, set_uvalue = pstate, /realize
	
if keyword_set(printplot) then begin
	ps_open, nextnameeps(objnm+'_observable_'+obsnm), /encaps, /color
	!p.font=1
endif else window, /free

; Create format strings for a two-level axis: 
ylabel=['noon', '3pm', '6pm', '9pm', 'mdnt', '3am', '6am', '9am', 'noon']
dummy = LABEL_DATE(DATE_FORMAT=['%M']) 
jan01 = julday(01,01,year, 0, 0, 0)
dec31 = julday(12,31,year, 23,59,59)
plot,[0,0],[0,0],thick=2, $
/xsty, xra=[jan01,dec31], $
/ysty, yra = [0d,24d], $
xtickunits=['TIME'], $
xtickformat='LABEL_DATE', $
xticks=12, $
;ytickunits=['TIME'], $
yticks=8, $
ytickname=ylabel, $
xtitle='Month', $
ytitle='Local ST' , $
title=objnm+' Observability at '+obsnm+' '+$
greek('alpha')+'='+strt(floor(rah))+'h'+strt(floor(ram))+'m'+strt(floor(ras))+'s'+$
' '+$
greek('delta')+'='+strt(floor(decd))+'d'+strt(floor(decm))+'m'+strt(floor(decs))+'s'

;stop
loadct, 39, /silent

days=dindgen(365)

;the resolution (in minutes):
if ~keyword_set(resolution) then resolution=30d

jan01noon = julday(01,01,year,12,0,0)
for day = 0d, 364 do begin
	mins = 24d * 60d / resolution
	jd = jan01noon+days[day]+dindgen(mins)/mins
	
	njd = n_elements(jd)
	rafullarr = dblarr(njd) + rafull
	decfullarr = dblarr(njd) + decfull

	alt=dblarr(mins)
	altsun=dblarr(mins)
	sunpos, jd, rasunarr, decsunarr

	;first for the object:
	eq2hor, rafullarr, decfullarr, jd, alt, az, $
	ha1, lat=obsrvtrylat, lon=obsrvtrylon, altitude=obsrvtryalt
	
	;then for the sun:
	eq2hor, rasunarr, decsunarr, jd, altsun, azsun, $
	hasun, lat=obsrvtrylat, lon=obsrvtrylon, altitude=obsrvtryalt

	if keyword_set(moon) then begin
		moonpos, jd, ramoonarr, decmoonarr
		;then for the moon:
		eq2hor, ramoonarr, decmoonarr, jd, altmoon, azmoon, $
		hasun, lat=obsrvtrylat, lon=obsrvtrylon, altitude=obsrvtryalt
		moonval= abs(rasunarr - ramoonarr)
		moonval = abs(360d*(moonval gt 180d) - moonval)
	endif	

	if ~keyword_set(minalt) then minalt = 30d
	idxnaut = where((alt gt minalt) and (altsun lt -12d), dumct)
	if dumct gt 0 then output[day, idxnaut] = 1d
	print, '# times observable on',day, ' is: ', dumct
	
	for q=0, mins-2 do begin
		if((altsun[q+1] le -18d) and (altsun[q] gt -18)) $
			then astrset = q-1
		if((altsun[q+1] ge -18d) and (altsun[q] lt -18)) $
			then astrris = q-1
	endfor
    if astrris eq -1 then astrris = mins-1
	yastrset = 24d*([jd[astrset],jd[astrset]]+tzoff- floor(jd[0]))
	yastrris = 24d*([jd[astrris],jd[astrris]]+tzoff- floor(jd[0]))
	yastrris = yastrris + 24d * (yastrris lt 0)

	for q=0, mins-2 do begin
		if((altsun[q+1] le -12d) and (altsun[q] gt -12)) $
			then nautset = q-1
		if((altsun[q+1] ge -12d) and (altsun[q] lt -12)) $
			then nautris = q-1
	endfor
    if nautris eq -1 then nautris = mins-1
    
	ynautset = 24d*([jd[nautset],jd[nautset]]+tzoff- floor(jd[0]))
	ynautris = 24d*([jd[nautris],jd[nautris]]+tzoff- floor(jd[0]))
	ynautris = ynautris + 24d * (ynautris lt 0)

	for q=0, mins-2 do begin
		if((altsun[q+1] le 0d) and (altsun[q] gt 0d)) $
			then sunset = q-1
		if((altsun[q+1] ge 0d) and (altsun[q] lt 0d)) $
			then sunris = q-1
	endfor
    if sunris eq -1 then sunris = mins-1
    
	ysunset = 24d*([jd[sunset],jd[sunset]]+tzoff- floor(jd[0]))
	ysunris = 24d*([jd[sunris],jd[sunris]]+tzoff- floor(jd[0]))
	ysunris = ysunris + 24d * (ysunris lt 0)
	;	print, 'ysunris is: ', ysunris
	;	print, 'ysunset is: ', ysunset

	if keyword_set(printplot) then mnthick=8 else mnthick=2
	if keyword_set(moon) then begin
		loadct, 1, /silent
		oplot, [floor(jd[0]),floor(jd[0])], [0,24], $
		color=max(moonval), thick=mnthick
	endif
		
	loadct, 39, /silent
	if dumct gt 0 then begin	
		x = floor(jd[idxnaut])
		y = 24d * (jd[idxnaut] - floor(jd[idxnaut])+tzoff)
		y += 24d * (y lt 0)
		y -= 24d * (y ge 24)
		oplot, x, y, ps=8, symsize=0.5, color = 150.
	endif
	
	loadct, 3, /silent
	sunclr=150
	nautclr=100
	astrclr=50
	oplot, [floor(jd[0]),floor(jd[0])], ysunset, ps=8, color=sunclr, symsize=0.5
	oplot, [floor(jd[0]),floor(jd[0])], ysunris, ps=8, color=sunclr, symsize=0.5

	oplot, [floor(jd[0]),floor(jd[0])], ynautset, ps=8, color=nautclr, symsize=0.5
	oplot, [floor(jd[0]),floor(jd[0])], ynautris, ps=8, color=nautclr, symsize=0.5

	oplot, [floor(jd[0]),floor(jd[0])], yastrset, ps=8, color=astrclr, symsize=0.5
	oplot, [floor(jd[0]),floor(jd[0])], yastrris, ps=8, color=astrclr, symsize=0.5
	loadct, 39, /silent
	
	widget_control, (*pstate).percent, set_value=strt(round(day/365d*100d))+' %'
;	stop
endfor

;OVERPLOT THE TRANSIT WINDOW:
if ~keyword_set(no_transit) then begin
if ~keyword_set(orbitalper) then orbper=75.29d else orbper = orbitalper
if ~keyword_set(perunc) then orbperunc = 0.02d else orbperunc = perunc

for i=0, floor(365d/orbper) do begin
	if (keyword_set(transitjd) and keyword_set(transitunc)) then begin
	beginwin = transitjd - transitunc
	endwin = transitjd + transitunc
	endif else begin
	beginwin = julday(04,27,2010, 19,50,18) - i*orbperunc
	endwin =  julday(04,28,2010, 06,12,19) + i*orbperunc
	endelse
	winsize = endwin - beginwin
	transitarr = winsize * dindgen(1d3+1d)/1d3 + $
	beginwin + i*orbper + tzoff
	ytransitarr = (transitarr - floor(transitarr))*24d
	
	oplot, floor(transitarr), ytransitarr, ps=8, color=254
	
	if (keyword_set(transitjd) and keyword_set(transitdur)) then begin
	ingress = transitjd - transitdur/24d/2d ;half of the transit duration
	egress = transitjd + transitdur/24d/2d  ;on either side of the center
	endif else begin
	ingress= julday(04,27,2010, 22,27,9)
	egress= julday(04,28,2010, 03,35,27)
	endelse
	transitdurarr = egress - ingress
	durarr = transitdurarr*  dindgen(1d3+1d)/1d3 + $
	ingress + i*orbper +tzoff
	ydurarr = (durarr - floor(durarr))*24d
	oplot, floor(durarr), ydurarr, ps=8, color=190
endfor

print, 'expected ingress (LST): '
print, 'expected egress (LST): ' 

loadct, 39, /silent
oplot, [julday(02,01,year,0,0), julday(2,15,year,0,0)], [22.75,22.75],$
	 color=190, thick=3
xyouts, julday(2,20,year,0,0),22.5, 'Transit'

oplot, [julday(02,01,year,0,0), julday(2,15,year,0,0)], [21.25,21.25],$
	 color=254, thick=3
xyouts, julday(2,20,year,0,0),21, 'Transit Uncertainty'
endif ;keyword_set(no_transit)

if keyword_set(moon) then !p.color=255
othk=1
;FEBRUARY DOTS:
oplot, [julday(02,01,year,0,0), julday(02,01,year,0,0)],[0,24], linestyle=1, $
thick=othk
;MARCH DOTS:
oplot, [julday(03,01,year,0,0), julday(03,01,year,0,0)],[0,24], linestyle=1, $
thick=othk
;APRIL DOTS:
oplot, [julday(04,01,year,0,0), julday(04,01,year,0,0)],[0,24], linestyle=1, $
thick=othk
;MAY DOTS:
oplot, [julday(05,01,year,0,0), julday(05,01,year,0,0)],[0,24], linestyle=1, $
thick=othk
;JUNE DOTS:
oplot, [julday(06,01,year,0,0), julday(06,01,year,0,0)],[0,24], linestyle=1, $
thick=othk
;JULY DOTS:
oplot, [julday(07,01,year,0,0), julday(07,01,year,0,0)],[0,24], linestyle=1, $
thick=othk
;AUGUST DOTS:
oplot, [julday(08,01,year,0,0), julday(08,01,year,0,0)],[0,24], linestyle=1, $
thick=othk
;SEPTEMBER DOTS:
oplot, [julday(09,01,year,0,0), julday(09,01,year,0,0)],[0,24], linestyle=1, $
thick=othk
;OCTOBER DOTS:
oplot, [julday(10,01,year,0,0), julday(10,01,year,0,0)],[0,24], linestyle=1, $
thick=othk
;NOVEMBER DOTS:
oplot, [julday(11,01,year,0,0), julday(11,01,year,0,0)],[0,24], linestyle=1, $
thick=othk
;DECEMBER DOTS:
oplot, [julday(12,01,year,0,0), julday(12,01,year,0,0)],[0,24], linestyle=1, $
thick=othk
;NEXT JANUARY DOTS:
oplot, [julday(1,01,year+1,0,0), julday(1,01,year+1,0,0)],[0,24], linestyle=1, $
thick=othk

;TIME DOTS:
oplot, [julday(01,01,year,0,0), julday(2,01,year+1,0,0)],[3,3], linestyle=1, $
thick=othk
oplot, [julday(01,01,year,0,0), julday(2,01,year+1,0,0)],[6,6], linestyle=1, $
thick=othk
oplot, [julday(01,01,year,0,0), julday(2,01,year+1,0,0)],[9,9], linestyle=1, $
thick=othk
oplot, [julday(01,01,year,0,0), julday(2,01,year+1,0,0)],[12,12], linestyle=1, $
thick=othk
oplot, [julday(01,01,year,0,0), julday(2,01,year+1,0,0)],[15,15], linestyle=1, $
thick=othk
oplot, [julday(01,01,year,0,0), julday(2,01,year+1,0,0)],[18,18], linestyle=1, $
thick=othk
oplot, [julday(01,01,year,0,0), julday(2,01,year+1,0,0)],[21,21], linestyle=1, $
thick=othk
oplot, [julday(01,01,year,0,0), julday(2,01,year+1,0,0)],[24,24], linestyle=1, $
thick=othk

loadct, 3, /silent
oplot, [julday(09,01,year,0,0), julday(9,15,year,0,0)], [22.75,22.75], $
	color=sunclr, thick=3
xyouts, julday(9,20,year,0,0),22.5, 'Sunrise/set'
oplot, [julday(09,01,year,0,0), julday(9,15,year,0,0)], [21.25,21.25],$
	 color=nautclr, thick=3
xyouts, julday(9,20,year,0,0),21, 'Nautical Twilight'
oplot, [julday(09,01,year,0,0), julday(9,15,year,0,0)], [19.75,19.75],$
	 color=astrclr, thick=3
xyouts, julday(9,20,year,0,0),19.5, 'Astronomical Twilight'

!p.color=0
if keyword_set(printplot) then ps_close
;stop
end;observable.pro