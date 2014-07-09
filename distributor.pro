;+
;
;  NAME: 
;     distributor
;
;  PURPOSE: 
;   To distribute jobs to as many CPUs as possible. 
;
;  CATEGORY:
;      UTILITIES
;
;  CALLING SEQUENCE:
;
;      distributor
;
;  INPUTS:
;
;  OPTIONAL INPUTS:
;
;  OUTPUTS:
;    Will output a command that can be used to start your job
;
;  OPTIONAL OUTPUTS:
;
;  KEYWORD PARAMETERS:
;    
;  EXAMPLE:
;      distributor
;
;  MODIFICATION HISTORY:
;        c. Matt Giguere 2012.01.27 07:03:57 PM
;
;-
function distributor, $
help = help

if keyword_set(help) then begin
	print, '*************************************************'
	print, '*************************************************'
	print, '        HELP INFORMATION FOR distributor'
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

hostname = ['47uma', 'albert', 'athos', 'cecilia', 'centauri', $
'dartagnan', 'echelle', 'lyra', 'pianeti', 'planets', $
'porthos', 'proxima', 'ring', 'sayari', 'tauboo']

cores = [8, 12, 4, 2, 8, $
2, 2, 4, 2, 2, $
4, 8, 8, 2, 8]

model = ['MacPro41', 'MacPro51', 'iMac113', 'iMac112', 'MacPro31', $
'iMac112', 'Macmini52', 'iMac113',  'Macmini52', 'Macmini52', $
'iMac311', 'MacPro41', 'MacPro31', 'Macmini52', 'MacPro41']

sshport = [22, 22, 22, 22, 22, $
22, 22, 22, 22, 218, $
22, 22, 22, 22, 22]

comps = create_struct('hostname', hostname, 'cores', cores, 'model', model)

;spawn, 'ps -eo pid,comm,%cpu | sort -rk 3 | head', top10
;sysctl -a | grep core_count ; display the # of cores
;sysctl -a | grep physicalcpu_max ;# cores * # processors

;number of machines
nmachs = total(machs)
;

;echo "logmaker, '"$chi_date"', /over" | ssh -tY ctimac1 "cd /mir7/pro ; idl"
for mach=0, nmachs-1 do begin
comm = 'ssh -p '+strt(round(sshport[mach]))+' '+hostname[mach]
print, comm
spawn, comm
wait, 2
endfor


return, command
stop
end;distributor.pro