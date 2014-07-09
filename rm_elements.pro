;***********************************************************************
; NAME: RM_ELEMENTS
;																	   
; PURPOSE: To remove certain undesired elements from an array
;																	   
; CATEGORY: UTIL							   
;																	   
; CALLING SEQUENCE:													   
;																	   
;																	   
; INPUTS:															   
;	ARR: The initial array.
;	IND: An array containing the indices you want to remove. 
;
; OPTIONAL INPUTS:													   
;																	   
; KEYWORD PARAMETERS:	
;
; OUTPUTS:															   
;																	   
; OPTIONAL OUTPUTS:													   
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
;     c. Matt Giguere, Monday, March 31, 2008		
;***********************************************************************
function rm_elements, oarr, ind

arr = oarr
for i=0, n_elements(ind)-1 do begin
lo = ind[i]-(1+i)
hi = ind[i]+(1-i)
;print, 'lo is: ', lo
;print, 'hi is: ', hi
;print, 'n_elements(arr) is: ', n_elements(arr)

if (lo ge 0) and (hi lt n_elements(arr)) then begin
arr = [arr[0:lo], arr[hi:*]]
endif else begin
if lo lt 0 then arr = arr[1:*] else arr = arr[0:(hi-2)]
endelse
endfor ;i=0 -> #(ind)

return, arr
end; rm_elements.pro