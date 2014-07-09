;***********************************************************************
; NAME: 
;																	   
; PURPOSE: 
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
; SIDE EFFECTS:														   
;																	   
; RESTRICTIONS:														   
;																	   
; PROCEDURE:														   
;																	   
; EXAMPLE:			
;																	   
; MODIFICATION HISTORY:												   
;     c. Matt Giguere, Tuesday, April 15, 2008		
;***********************************************************************
pro overplot_colorbar

loadct, 0

plot, findgen(256), background = 255, color = 0

loadct, 13

colorbar, bottom = 50, ncolors = 206, divisions = 10, /fap, max = 1



end;