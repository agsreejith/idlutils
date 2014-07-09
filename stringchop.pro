;+
; NAME: STRINGCHOP.PRO
;
;
;
; PURPOSE: This function will take a floating point or double number 
; and chop it to two three significant digits. 
;
; CATEGORY:
;
;
;
; CALLING SEQUENCE:
;
;
;
; INPUTS:
;
;
;
; OPTIONAL INPUTS:
;
;
;
; KEYWORD PARAMETERS:
;
;
;
; OUTPUTS:
;
;
;
; OPTIONAL OUTPUTS:
;
;
;
; COMMON BLOCKS:
;
;
;
; SIDE EFFECTS:
;
;
;
; RESTRICTIONS:
;
;
;
; PROCEDURE:
;
;
;
; EXAMPLE:
;
;
;
; MODIFICATION HISTORY:
;
;-
function stringchop, num
num = strt(num)
ex = strmid(num, 3, 4, /reverse_offset)
sig = strmid(num, 0, 4)
num = float(sig+ex)
  return, num
end
