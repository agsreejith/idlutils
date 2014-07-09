;+
;
;  NAME: 
;     yalehost
;
;  PURPOSE: Return 1 if this is being run on an "astro.yale.edu"
;		otherwise return 0
;   
;
;  CATEGORY:
;      UTILITIES
;
;  CALLING SEQUENCE:
;
;      print, yalehost()
;
;  INPUTS: None
;
;  OPTIONAL INPUTS:
;
;  OUTPUTS: 1 or 0
;
;  EXAMPLE:
;      print, yalehost()
;
;  MODIFICATION HISTORY:
;        c. Matt Giguere 2013.02.13 15:19:20
;
;-
function yalehost

spawn, 'hostname', host

hostarr = strsplit(host, '.', /extract)
;stop
if n_elements(hostarr) ge 4 then begin
  domain = hostarr[-3]+'.'+hostarr[-2]+'.'+hostarr[-1]
  if domain eq 'astro.yale.edu' then yalecomp = 1 else yalecomp = 0
endif else yalecomp = 0

return, yalecomp
end;yalehost.pro