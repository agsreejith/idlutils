;+
;;  NAME: 
;     calform
;;  PURPOSE: 
;   To return the date in whatever format the user would like.
;
;  CATEGORY:
;      UTILITIES
;
;  CALLING SEQUENCE:
;
;      calform
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
;      calform
;
;  MODIFICATION HISTORY:
;        c. Matt Giguere 2011.09.20 06:26:26 PM
;		20111025~MJG: modified to be a CASE and added many new forms and the help
;
;-
function calform, $
julian, $
form = form, $
help = help

if keyword_set(help) then begin
	print, '*************************************************'
	print, '*************************************************'
	print, '        HELP INFORMATION FOR CALFORM'
	print, 'KEYWORDS: '
	print, ''
	print, 'HELP: Use this keyword to print all available arguments'
	print, ''
	print, 'JULIAN: The julian date you would like the date for'
	print, ''
	print, 'FORM: The format the string date will be returned as'
	print, ''
	print, '*************************************************'
	print, '                     EXAMPLE                     '
	print, "IDL>print, calform(systime(/julian), f='yymmdd')"
	print, 'the date is: 111025'
	print, '111025'
	print, 'IDL> '
	print, '*************************************************'
	stop
endif

caldat, julian, mon, da, yr

	yr4 = strmid(strt(yr), 0, 4)
	yr2 = strmid(strt(yr), 2, 2)
	mon2 = strt(long(mon), f='(I02)')
	da2 = strt(long(da), f='(I02)')


case form of
'yyyymmdd':		date = yr4+mon2+da2
'yyyymm':		date = yr4+mon2
'yymmdd': 		date = yr2+mon2+da2
'yymm': 		date = yr2+mon2
'yy':			date = yr2
'mm':			date = mon2
'dd':			date = da2
endcase

print, 'the date is: ', date
return, date
end;calform.pro