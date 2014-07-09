pro create_hd_cat
;PURPOSE: This procedure restores the Henry Draper 
;Catalog that was downloaded from Vizier/SIMBAD
;and stores it in an IDL data structure. 
;
;information retrieved from:
;http://vizier.u-strasbg.fr/viz-bin/VizieR?-source=III/135
;
;c. 2010.04.11 ~MJG
;

nel=272151d ;number of elements
ra = dblarr(nel) ;right ascension J2000
dec = dblarr(nel) ;declination J2000
hdnum = dblarr(nel) ;henry draper number
dm=strarr(nel)
rab1900=strarr(nel)
deb1900=strarr(nel)
spectype=strarr(nel) ;spectral type


get_lun, nf
openr, nf, 'idl/exoidl/data/hd_catalog_135.tsv'

line = ' '
;The following FOR loop prints the header information
;from Vizier:
for i=0, 37 do begin
	readf, nf, line
	print, 'the line is: ', line
endfor
stop
i=1LL
while ~EOF(nf) do begin
	readf, nf, line
	print, 'the line is: ', line
	;stop
	vars = strsplit(line, ';', /extract)
	ra[i] = vars[0]
	dec[i] = vars[1]
	hdnum[i] = vars[2]
	dm[i]=vars[3]
	rab1900[i]=vars[4]
	deb1900[i]=vars[5]
	spectype[i]=vars[12]
	
;	print, 'line is: ', line
;	print, 'ra is: ', ra[i]
;	print, 'dec is: ', dec[i]
;	print, 'hdnum is: ', hdnum[i]
;	print, 'spectral type is: ', spectype[i]
;
;	if ~(i mod 10) then stop	
	i++
endwhile

free_lun, nf

hdecat = replicate(create_struct($
'ra', 0d, $
'dec', 0d, $
'hdnum', 0LL, $
'dm', '', $
'rab1900', '', $
'deb1900', '', $
'spectype', ''), nel)
hdecat.ra = ra
hdecat.dec = dec
hdecat.hdnum = hdnum
hdecat.dm = dm
hdecat.rab1900 = rab1900
hdecat.deb1900 = deb1900
hdecat.spectype = spectype

stop
save, hdecat, filename='idl/exoidl/data/hdecat.dat'
stop
end;create_hd_cat.pro