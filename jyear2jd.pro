;***********************************************************************
; NAME: 	JYEAR2JD
;																	   
; PURPOSE:    Converts from Jyears to jd. 
;																	   
; CATEGORY: EXOPLANETS							   
;																	   
; CALLING SEQUENCE:													   
;																	   
;																	   
; INPUTS:															   
;																	   
; OPTIONAL INPUTS:													   
;																	   
; KEYWORD PARAMETERS:												   
;																	   
; OUTPUTS:															   
;																	   
; OPTIONAL OUTPUTS:													   
;																	   
; COMMON BLOCKS:													   
;																	   
; SIDE EFFECTS:														   
;																	   
; RESTRICTIONS:														   
;																	   
; PROCEDURE:														   
;																	   
; EXAMPLE:															   
;																	   
; MODIFICATION HISTORY:												   
;     c. Matt Giguere, Wednesday, October 10, 2007						   
;***********************************************************************
function jyear2jd, arr, printdate = printdate
vtimedec =arr - floor(arr)
ifvtimes = isleap(floor(arr))

vtimedec = ifvtimes * vtimedec * 366.d + (~ ifvtimes) * vtimedec * 365.d

jdvtimes = double(juldayarr(1, 1, double(floor(arr)))) + vtimedec

if keyword_set(printdate) then print, jul2cal(jdvtimes)

return, jdvtimes

end ;jyear2jd.pro