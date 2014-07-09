;+
;;  NAME: 
;     fits_add_kw
;;  PURPOSE: 
;   To add a keyword to a fits header
;
;  CATEGORY:
;      CHIRON
;
;  CALLING SEQUENCE:
;
;      fits_add_kw
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
;      fits_add_kw
;
;  MODIFICATION HISTORY:
;        c. Matt Giguere 2011.07.07 04:02:42 PM
;
;-
pro fits_add_kw, $
filename = filename, $
keyword = keyword, $
value = value

h = headfits(filename)
sxaddpar, h, keyword, value
modfits, filename, 0, h


end;fits_add_kw.pro