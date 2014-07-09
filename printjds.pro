pro printjds, cf3, strout = strout
;PURPOSE: This program is intended to print the calendar
;	dates of the observations input
;
;OPTIONAL OUTPUT:
;	STROUT: The string output of the result
;
; 2010.10.25 ~MJG
;
if size(cf3, /type) ne 8 then jds = cf3 else jds = cf3.jd
if nume(jds) le 1 then jds = [jds, jds]
strout = transpose(jul2cal(jds + 2.44d6))
print, strout

end;printjds.pro