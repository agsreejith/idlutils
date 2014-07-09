;***********************************************************************
; NAME: GRADECALC
;																	   
; PURPOSE: TO CALCULATE THE AMOUNT OF POINTS TO DEDUCT GIVEN THE TOTAL
;	POINTS POSSIBLE
;																	   
; CATEGORY: GTA							   
;																	   
; CALLING SEQUENCE:													   
;																	   
;																	   
; INPUTS:		
;	TOT: The total points possible
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
;	gradecalc, 58
;	
; MODIFICATION HISTORY:												   
;     c. Matt Giguere, Thursday, May 08, 2008		
;***********************************************************************
pro gradecalc, tot

tot = double(tot)

;amount deducted:
ded = transpose(reverse(findgen(tot)+1 - tot))
totp = transpose(reverse(findgen(tot)+1))
score = totp/tot*10

print, ' '
print, '------------------------------------------------'
print, ' Amount Deducted   |  Total Points |    Score '
print, '------------------------------------------------'
print, [ded, totp, score]

end;