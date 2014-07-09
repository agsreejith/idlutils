;***********************************************************************
; NAME: SPACESTRING
;																	   
; PURPOSE: This function outputs a string of spaces of the desired input 
;	length, len
;																	   
; CATEGORY: UTIL							   
;																	   
; CALLING SEQUENCE:
;
;IDL> print, 'beginning'+spacestring(5)+'end'
;beginning     end
;IDL> 
;																	   
; INPUTS:															   
;	LEN: the number of spaces you want your string to be. 
;
; OUTPUTS:															   
;	A string of spaces. 
;																	   
; EXAMPLE:			
;																	   
;IDL> print, 'beginning'+spacestring(5)+'end'
;beginning     end
;IDL> 
;
; MODIFICATION HISTORY:												   
;     c. Matt Giguere, Monday, June 16, 2008		
;***********************************************************************
function spacestring, len
arr = replicate(' ', len)
return, strjoin(arr)
end;