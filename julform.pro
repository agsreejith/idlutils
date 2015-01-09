;+
;
;  NAME: 
;     julform
;
;  PURPOSE: To extract the julian date given the calendar form
;   
;
;  CATEGORY:
;      UTILITIES
;
;  CALLING SEQUENCE:
;
;      julform
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
;      julform
;
;  MODIFICATION HISTORY:
;        c. Matt Giguere 2013.03.13 14:15:09
;
;-
function julform, $
date = date, $
form = form

;convert to string and trim any whitespace
date = strt(date)

if ~keyword_set(form) then form = 'yymmdd'

if form eq 'yymmdd' then begin
  year = 2000L + long(strmid(date,0,2))
  month = long(strmid(date,2,2))
  day = long(strmid(date,4,2))
endif

if form eq 'yyyymmdd' then begin
  year = long(strmid(date,0,4))
  month = long(strmid(date,4,2))
  day = long(strmid(date,6,2))
endif

return, julday(month, day, year)
end;julform.pro