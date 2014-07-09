;+
;
;  NAME: 
;     suntimes
;
;  PURPOSE: TO COMPUTE THE SUNRISE AND SUNSET AND TWILIGHT TIMES
;   
;
;  CATEGORY:
;      GENERAL ASTRONOMY
;
;  CALLING SEQUENCE:
;
;      suntimes
;
;  INPUTS:
;
; OPTIONAL KEYWORDS:
;	DATE: The date that you want suntimes for in the format yymmdd
;	POSTPLOT: PRINT A COLOR ENCAPSULATED POSTSCRIPT PLOT INSTEAD
;       OF PRINTING TO SCREEN
;	RESOLUTION: The resolution (in minutes) used to calculate
;				the observability of the object of interest
;   OBSERVATORY: If you want to know where the object is visible, you can
;		either enter the LAT, LON of the location of interest, or the 
;       observatory abbreviation listed below
;   STIMES: An optional output structure that contains the sunrise/set,
;		nautical twilight and astronomical twilight times in a structure
;
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
;  OUTPUTS:
;
;  OPTIONAL OUTPUTS:
;
;  KEYWORD PARAMETERS:
;    
;  EXAMPLE:
;      suntimes
;
;  MODIFICATION HISTORY:
;        c. Matt Giguere 2012.07.12 11:28:21 AM
;
;-
pro suntimes, $
help = help, $
postplot = postplot, $
resolution=resolution, $
observatory=observatory, $
moon=moon, $
minalt=minalt, $
stimes=stimes, $
hdnum=hdnum, $
date=date


if keyword_set(help) then begin
	print, '*************************************************'
	print, '*************************************************'
	print, '        HELP INFORMATION FOR suntimes'
	print, 'KEYWORDS: '
	print, ''
	print, 'HELP: Use this keyword to print all available arguments'
	print, ''
	print, ''
	print, ''
	print, '*************************************************'
	print, '                     EXAMPLE                     '
	print, "IDL>suntimes, observatory='ctio', date='120712', resolution=1"
	print, 'IDL> '
	print, '*************************************************'
	stop
endif

loadct, 39, /silent
usersymbol, 'circle', /fill, size_of_sym = 0.5

if ~keyword_set(resolution) then resolution = 5d
output = dblarr(365, 24d*3600d / resolution)

if ~keyword_set(observatory) then obsnm = 'ctio' else obsnm=observatory
observatory, obsnm, obs_struct
obsrvtrylat=obs_struct.latitude
obsrvtrylon=-obs_struct.longitude
obsrvtryalt=obs_struct.altitude
tzoff = -obs_struct.tz/24d

if ~keyword_set(year) and ~keyword_set(date) then year = '2012'
if ~keyword_set(year) and keyword_set(date) then year = '20'+strmid(date,0,2)
jan01noon = julday(01,01,year,12,0,0)
days = 0d & day = 0d
mins = 24d * 60d / resolution
jd = jan01noon+days[day]+dindgen(mins)/mins
if keyword_set(date) then jd = julday(strmid(date,2,2), strmid(date,4,2), year, 12, 0, 0)+dindgen(mins)/mins
altsun=dblarr(mins)
sunpos, jd, rasunarr, decsunarr

;then for the sun:
eq2hor, rasunarr, decsunarr, jd, altsun, azsun, $
hasun, lat=obsrvtrylat, lon=obsrvtrylon, altitude=obsrvtryalt

;ASTRONOMICAL TWILIGHT:
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

;NAUTICAL TWILIGHT:
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

;SUNRISE AND SUNSET:
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

loadct, 3, /silent
sunclr=150
nautclr=100
astrclr=50
x=jul2cal(42)
PRINT, '**********************************************************************'
PRINT, '             UTC SUN TIMES FOR '+DATE+' FROM '+OBSNM
PRINT, '**********************************************************************'
print, 'SUNRISE  | SUNSET : ', jul2cal(jd[sunset]) , ' | ', jul2cal(jd[sunris])
print, 'NAUTRIS  | NAUTSET: ', jul2cal(jd[nautset]), ' | ', jul2cal(jd[nautris])
print, 'ASTRISE  | ASTSET : ', jul2cal(jd[astrset]), ' | ', jul2cal(jd[astrris])
PRINT, '**********************************************************************'

PRINT, '**********************************************************************'
PRINT, '             UTC'+strt(-obs_struct.tz)+' SUN TIMES FOR '+DATE+' FROM '+OBSNM
PRINT, '**********************************************************************'
print, 'SUNRISE  | SUNSET : ', jul2cal(jd[sunset]+tzoff) , ' | ', jul2cal(jd[sunris]+tzoff)
print, 'NAUTRIS  | NAUTSET: ', jul2cal(jd[nautset]+tzoff), ' | ', jul2cal(jd[nautris]+tzoff)
print, 'ASTRISE  | ASTSET : ', jul2cal(jd[astrset]+tzoff), ' | ', jul2cal(jd[astrris]+tzoff)
PRINT, '**********************************************************************'

stimes = create_struct( $
  'sunset', jd[sunset], $
  'sunrise', jd[sunris], $
  'nautset', jd[nautset], $
  'nautris', jd[nautris], $
  'astrset', jd[astrset], $
  'astrris', jd[astrris])



;stop
end;suntimes.pro