;+
;;  NAME: 
;     time2number
;;  PURPOSE: 
;   
;
;  CATEGORY:
;      UTILITIES
;
;  CALLING SEQUENCE:
;
;      time2number
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
;      time2number
;
;  MODIFICATION HISTORY:
;        c. Matt Giguere 2011.06.15 04:47:04 PM
;
;-
function time2number, time

if strmid(time, 0, 1) eq '-' then eh = 3 else eh = 2

hrs = double(strmid(time, 0, eh))
mins = strmid(time, eh+1, 2)
secs = strmid(time, eh+4, strlen(time)-(eh+4))
number = hrs + mins/60d + secs/3600d
if eh eq 3 then number = hrs - mins/60d - secs/3600d
return, number
end;time2number.pro