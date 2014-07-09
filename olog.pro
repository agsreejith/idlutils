;+
;
;  NAME: 
;     olog
;
;  PURPOSE: 
;   
;
;  CATEGORY:
;      UTILITIES
;
;  CALLING SEQUENCE:
;
;      olog
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
;      olog
;
;  MODIFICATION HISTORY:
;        c. Matt Giguere 2012.08.14 12:02:20 PM
;
;-
pro olog, $
date, $
help = help, $
postplot = postplot

!p.color=0
!p.background=255
loadct, 39, /silent
usersymbol, 'circle', /fill, size_of_sym = 0.5

if keyword_set(help) then begin
	print, '*************************************************'
	print, '*************************************************'
	print, '        HELP INFORMATION FOR olog'
	print, 'KEYWORDS: '
	print, ''
	print, 'HELP: Use this keyword to print all available arguments'
	print, ''
	print, ''
	print, ''
	print, '*************************************************'
	print, '                     EXAMPLE                     '
	print, "IDL>"
	print, 'IDL> '
	print, '*************************************************'
	stop
endif
date = strt(long(date))
spawn, 'open -a textwrangler /tous/mir7/logsheets/2012/'+date+'.log'

end;olog.pro