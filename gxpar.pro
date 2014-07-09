;+
;;  NAME: 
;     gxpar
;;  PURPOSE: 
;   To read just one keyword from a FITS header.
;
;  CATEGORY:
;      UTILITIES
;
;  CALLING SEQUENCE:
;
;      res = gxpar(filename = filename, keyword = keyword)
;
;  INPUTS:
;		FILENAME: The filename of the FITS file you want to read in the FITS header keyword from
;		
;		KEYWORD: The FITS header keyword that you want to read. 
;
;  OUTPUTS:
;
;  EXAMPLE:
;		IDL> print, gxpar(filename = '/mir7/raw/110530/qa37.3309.fits', keyword = 'DECKER') 
;		narrow_slit
;		IDL> 
;
;
;  MODIFICATION HISTORY:
;        c. Matt Giguere 2011.07.11 03:38:32 PM
;
;-
function gxpar, $
filename = filename, $
keyword = keyword


return, fxpar(headfits(filename, /silent), keyword)
end;gxpar.pro