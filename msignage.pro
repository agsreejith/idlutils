;+
;
;  NAME: 
;     msignage
;
;  PURPOSE: 
;    Simply to affix a timestamp and my initials to a plot
;
;  CATEGORY:
;      PLOTTING
;
;  CALLING SEQUENCE:
;
;      msignage
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
;       DATE: This will stamp on the date
;		  TIME: This will stamp on the time
;		  INITS: This will tack on my initials
;    
;  EXAMPLE:
;      msignage
;
;  MODIFICATION HISTORY:
;        c. Matt Giguere 2011.02.16 02:58:35 PM
;
;-
pro msignage, date=date, time=time, inits=inits

!p.charsize=.6

if ~keyword_set(time) then outpt=jul2cal(systime(/julian), /datdash) $
	else outpt=jul2cal(systime(/julian), /dashcol)
if keyword_set(inits) then outpt=outpt+'-MJG'
print, outpt
xyouts, .99, .99, outpt, color = 0.0, alignment=1., /normal

end;msignage.pro