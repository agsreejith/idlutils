;+
;NAME: COLUMBUSCSV2GPX
;
;PURPOSE: This procedure will convert the CSV track files produced
;         by the Columbus V-900 to GPX.
;
; INPUT:
;
;   FILEN: The filename of the CSV file you want to convert.
;-
pro ColumbusCSV2GPX, filen

openr, lun, filen, /get_lun
header=''

readf, lun, header

;stop

idx = LONARR(10000000)
tag = DBLARR(10000000)
datt = DBLARR(10000000)
timm = DBLARR(10000000)
lat = DBLARR(10000000)
lon = DBLARR(10000000)
alt = DBLARR(10000000)
speed = DBLARR(10000000)
heading = DBLARR(10000000)
vox = DBLARR(10000000)

count = 0LL
;stop
while ~EOF(lun) do begin

;readf, lun, idx, tag, datt, timm, lat, lon, alt, speed, heading, vox
;readf, lun, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10
;readf, lun, data
readcol, filen, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10
stop
count++
endwhile
stop
idx = idx[0:count-1]
tag = tag[0:count-1]
datt = datt[0:count-1]
timm = timm[0:count-1]
lat = lat[0:count-1]
lon = lon[0:count-1]
alt = alt[0:count-1]
speed = speed[0:count-1]
heading = heading[0:count-1]
vox = vox[0:count-1]
stop
;NOW WRITE THE FILE

filenlen = strlen(filen)
newname = strmid(filen, 0, filenlen-4)+'.GPX'
stop






for i=0LL, count-1 do begin

endfor ;create the XML file
stop
end;ColumbusCSV2GPX.pro