;+
;
;  NAME: 
;     mygauss
;
;  PURPOSE: 
;   
;
;  CATEGORY:
;      UTILITIES
;
;  CALLING SEQUENCE:
;
;      mygauss
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
;      mygauss
;
;  MODIFICATION HISTORY:
;        c. Matt Giguere 2012.10.18 02:45:29 PM
;
;-
function mygauss, X, P

gaussian = p[0]*exp(-1. * ((X - p[1])/p[2])^2.)

;add offset:
if n_elements(p) gt 3 then gaussian += p[3]

;add linear term:
if n_elements(p) gt 4 then  gaussian += p[4]*X

;add quadratic term:
if n_elements(p) gt 5 then  gaussian += p[5]*X^2

return, gaussian
end;mygauss.pro