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

return, p[0] + GAUSS1(X, P[1:3])
end;mygauss.pro