;+
;;  NAME: 
;     lmst
;;  PURPOSE: To convert from UT1 to LMST
;   
;
;  CATEGORY:
;      CHIRON
;
;  CALLING SEQUENCE:
;
;      lmst
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
;      lmst, location='ctio', jd = juliandate
;
;  MODIFICATION HISTORY:
;        c. Matt Giguere 2011.09.06 02:37:20 PM
;
;-
pro lmst, $
location = location, $
jd = jd

if ~keyword_set(location) then location='ctio'
if ~keyword_set(jd) then jd = systime(/julian, /utc)

d = jd - 2451545.0d
T = d / 36525d

GMST = 18.697374558d + 24.06570982441908d * d

GMST2 = GMST mod 24

print, 'GMST in hours: ', GMST2

GMSTh = floor(GMST2)
GMSTm = floor((GMST2 - floor(GMST2))*60d)
GMSTs = ((GMST2 - floor(GMST2))*60d - GMSTm)*60d
print, 'GMST: ', strt(GMSTh), ' h ', strt(GMSTm), ' m ', strt(GMSTs)

;**********************************************
;NOW TO CONVERT TO LMST:
;**********************************************
if location eq 'ctio' then LMST2 = GMST2 - 4.721d

LMSTh = floor(LMST2)
LMSTm = floor((LMST2 - LMSTh)*60d)
LMSTs = ((LMST2 - LMSTh)*60d - LMSTm)*60d
print, 'LMST: ', strt(LMSTh), ' h ', strt(LMSTm), ' m ', strt(LMSTs)


stop
end;lmst.pro