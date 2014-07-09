;***********************************************************************
; NAME: RANDOMA
;																	   
; PURPOSE: To generate NUM true random numbers in a range between
;			MINV and MAXV
;																	   
;																	   
; MODIFICATION HISTORY:												   
;     c. Matt Giguere, Sunday, November 23, 2008		
;***********************************************************************
function randoma, minv = minv, maxv = maxv, num = num

if ~keyword_set(num) then num = 20
if ~keyword_set(minv) then minv = 0
if ~keyword_set(maxv) then maxv = 100

rnd = obj_new('MGrndRandom')
result = rnd -> getIntegers(num, min=minv, max=maxv, error=error)

return, result
end;randoma.pro