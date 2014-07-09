;+
;
;  NAME: 
;     printrvs_tex
;
;  PURPOSE: To print the radial velocities for a given star to a
;		file in LaTeX form. This routine will also produce a 
;		periodogram of 
;   
;
;  CATEGORY:
;      N2K
;
;  CALLING SEQUENCE:
;
;      printrvs_tex
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
;      printrvs_tex
;
;  MODIFICATION HISTORY:
;        c. Matt Giguere 2012.09.08 06:18:06 PM
;
;-
pro printrvs_tex, $
help = help, $
postplot = postplot, $
hd = hd, $
hip = hip

!p.color=0
!p.background=255
loadct, 39, /silent
usersymbol, 'circle', /fill, size_of_sym = 0.5

if keyword_set(help) then begin
	print, '*************************************************'
	print, '*************************************************'
	print, '        HELP INFORMATION FOR printrvs_tex'
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



stop
if keyword_set(postplot) then begin
   fn = nextnameeps('plot')
   thick, 2
   ps_open, fn, /encaps, /color
endif

if keyword_set(postplot) then begin
   ps_close
endif

stop
end;printrvs_tex.propro 

restore, '../vst163607.dat'

restore, '../ksval.dat'

nel=n_elements(ksval.obsnm)
bstr=strarr(nel)
for i=0, nel-1 do bstr[i] = $
	strmid(ksval[i].obsnm, 1, strlen(ksval[i].obsnm))
nobs = n_elements(cf3)	
rstr=strarr(nobs)
x = dblarr(nobs)
for i=0, nobs-1 do begin
	rstr[i] = $
	strmid(cf3[i].obnm, 1, strlen(cf3[i].obnm))
	x[i] = where(bstr eq rstr[i])
endfor
;stop	

print,  ksval[x].objnm

print, 'For a check, above is the object name for each', $
	' element you are retrieving the SHK value for. '

svals = ksval[x].sval
;stop


get_lun, fnum
fdat = jul2cal(systime(/julian), /straightdate)
fname='rvtable163607_'+fdat+'.tex'
openw, fnum, fname

printf, fnum, '\begin{deluxetable}{rrrr}'
printf, fnum, '\tablenum{2}'
printf, fnum, '\tablecaption{Radial Velocities for HD~163607 \label{tab:rvs}}'
printf, fnum, '\tablewidth{0pt}'
printf, fnum, '\tablehead{\colhead{JD}  & \colhead{RV}  ',$
'& \colhead{$\sigma_{RV}$} & \colhead{$S_{HK}$}   \\'
printf, fnum, '\colhead{-2440000}  & \colhead{(\ms)}   ',$
'& \colhead{(\ms)}  } '
printf, fnum, '\startdata'

i=0
print, strt(cf3[i].jd, f='(D11.4)')+$
'  &  '+strt(cf3[i].mnvel, f='(D24.2)')+$
'  &  '+strt(cf3[i].errvel, f='(D22.2)')+'& 0  \\  '
;stop
for i=0, n_elements(cf3)-1 do begin
printf,fnum, strt(cf3[i].jd, f='(D11.4)')+$
'  &  '+strt(cf3[i].mnvel, f='(D24.2)')+$
'  &  '+strt(cf3[i].errvel, f='(D22.2)')+$
' & '+strt(svals[i], f='(D22.3)')+'  \\  '
endfor

printf, fnum, '\enddata'
printf, fnum, '\end{deluxetable}'
;printf, fnum, '\clearpage'


close, fnum

cf = create_struct('jd', cf3[0].jd, 'mnvel', svals[0])
cf = replicate(cf, 29)                                
cf.jd = [cf3[0:1].jd, cf3[3:29].jd]
cf.mnvel = [svals[0:1], svals[3:29]]

pergram, cf

spawn, 'open '+fname


stop
end;print163607rvs_tex.pro
